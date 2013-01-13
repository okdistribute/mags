#!/bin/python3
import sys
import os
import shutil
import subprocess
import fcntl
import select
import signal


class P423Grader:
  """
  AUTHOR: Christopher Zakian | czakian@indiana.edu

  This class is an autograder for the MAGS autograding framework 
  located at: git@github.com:arcfide/mags.git

  We only handle one student at a time in this class.
  for a script to loop over multiple students, see the 
  test_runner.py script in the same directory. 
  """

  def __init__(self, solution_hash, student_info, options=None, cmd="scheme"):
    """
    Initialize this object.

    ARGS: 
    solution_hash: is a github hash corresponding to a commit that contains
    the correct set of files for this assignment. 

    student_info: consists of a string containing a username and github hash
    separated by a "/" character. 

    options: is either all or a pass name. if a pass name is supplied, only
    the pass in question is tested. The latter option is currently not supported,
    but will be supported in the near future. 

    cmd: this determines which option the script tries first. if scheme is 
    selected, the script will first look for a scheme compiler directory, and
    if it is not found, it will then look for a haskell directory. if haskell
    is specfied, only haskell will be tried. 


    RETURNS: this object
    """

    username,student_hash = student_info.split("/")
    repo = "p423-523-sp13"

    self.student_hash = student_hash
    self.options = options
    self.sdir = "Compiler"
    self.hdir = "CompilerHs"
    self.username = username
    self.framework = "framework-private"
    self.cmd = cmd

    cwd = os.getcwd()

    cmd = "git clone git@github.iu.edu:"+repo+"/"+self.framework+".git"
    print("pulling framework: " + cmd)
    os.system(cmd)
    os.chdir(self.framework)
    print("checking out commit: " + solution_hash)
    os.system("git checkout " + solution_hash)
    os.chdir(cwd)

    os.system("git clone git@github.iu.edu:"+repo+"/"+username+".git")
    os.chdir(username)
    os.system("git checkout " + student_hash)
    os.chdir(cwd)

  def grade(self):
    """
    A dispatching function that directs the control flow to either
    a single pass test or a complete compiler test.

    RETURNS: the resulting xml from the test suite, or None if there is
    an error while running the suite. 
    """

    try:
      if self.options == "all":
        return self.__do_grade_all()
      elif self.options:
        return self.__do_grade_single()
      else:
        raise RuntimeError("bad option passed in from the user. Allowable options are: all,single,both")
    except:
      print("caught an exception in grading: " + self.username + " user could not be graded")
      return None

  def __do_grade_all(self):
    """
    Performs the action of cloning the student's repository and 
    running it against the solution test suite.

    RETURNS: the xml that results from running the test suite, or None if there is an error.
    """

    report = ""

    if self.student_hash == "HEAD":

      # if a student hasn't submitted to the branch, the revision
      # will return 'HEAD' for the hash instead of an actual hash
     report = """ <grading-results>
                 <test-group name =\"valid-tests NO SUBMISSION\">
                    <test-result expected=\"pass\" got=\"fail\"/>
                  </test-group>
                  <test-group name =\"invalid-tests NO SUBMISSION\">
                    <test-result expected=\"pass\" got=\"fail\"/>
                  </test-group>
                </grading-results>
              
               """
     return report

    cwd = os.getcwd()
    src = cwd+"/"+self.username+"/"+self.sdir
    dest = cwd+"/"+self.framework+"/"+self.sdir

    print("copying " + src + " to " + dest)
    try:
      self.copytree(src, dest)
    except:
      print("scheme compiler not found. trying haskell")
      try:
        self.cmd = 'haskell'
        src = cwd+"/"+self.username+"/"+self.hdir
        dest = cwd+"/"+self.framework+"/"+self.hdir
      except: 
        raise RuntimeError("No valide compiler directories found")

    os.chdir(cwd+"/"+self.framework)
    print("changed directory to: " + os.getcwd() + "running makefile")

    # start up the scheme process by calling the makefile in the framework repository
    p = subprocess.Popen(
           ["make", self.cmd], 
           stdout=subprocess.PIPE, 
           stderr=subprocess.PIPE, 
           stdin=subprocess.PIPE
        )

    # set the file to be non blocking
    fcntl.fcntl(
        p.stdout.fileno(),
        fcntl.F_SETFL,
        fcntl.fcntl(p.stdout.fileno(), fcntl.F_GETFL) | os.O_NONBLOCK,
    )

    report += "<grading-results>"

    garbage = True
    # loop until we don't get any more output
    while p.poll() == None:
      readx = select.select([p.stdout.fileno()], [], [])[0]
      if readx:
        try:
          chunk = p.stdout.readline().decode("utf-8")

          # quit on EOF
          if chunk == "<EOF/>":
            p.send_signal(signal.SIGTERM)
            break
        except:
          p.send_signal(signal.SIGTERM)
          break

        # there is some garbage text that 
        # scheme and the scripts print out
        # before it gets to the stuff we care about
        # the first test-group seen means we have 
        # started to get good data. 
        if garbage:
          if 'test-group' in chunk:
            garbage = False
        else:
          report += chunk

    report += "</grading-results>"
    
    os.chdir(cwd)
    print(report)
    return report

  def __do_grade_single():

    """
      FIXME:
      CURRENTLY UNSUPPORTED: THIS METHOD DOES NOT WORK!
    """
    cwd = os.getcwd()
    shutil.copy2(cwd+"/"+self.username+"/"+self.sdir+"/"+self.options, cwd+"/"+self.framework)
    os.chdir(cwd+"/"+self.framework)
    p = subprocess.Popen(["make", self.cmd], stdout=subprocess.PIPE)
    result_xml = p.communicate()
    os.chdir(cwd)
    return result_xml

  def cleanup(self):
    """
    Recursively removes the framework and the student's repository.
    This is preferable to keeping any sources around so that each time
    we run a student's work, we are guaranteed an uncontaminated framework
    and directory structure.

    RETURNS: None
     
    """
    os.system("rm -rf framework-private")
    os.system("rm -rf "+self.username)
 
  def copytree(self, src, dst, symlinks=False, ignore=None):
    """
    A custom copytree method (same as shutil.copytree) but without
    the requirement that the directory not exist
    this was taking from a stack overflow article

    """
      if not os.path.exists(dst):
          os.makedirs(dst)
      for item in os.listdir(src):
          s = os.path.join(src, item)
          d = os.path.join(dst, item)
          if os.path.isdir(s):
              copytree(s, d, symlinks, ignore)
          else:
              if not os.path.exists(d) or os.stat(src).st_mtime - os.stat(dst).st_mtime > 1:
                  shutil.copy2(s, d)
      
  
def main():

  if len(sys.argv) < 3:
    raise RuntimeError(
      """invalid number of arguments. 
         Usage: <solution hash> <username/student_hash> <all|single-pass-name> [<test|scheme|haskell>])
      """)
  grader = P423Grader(sys.argv[1],sys.argv[2],sys.argv[3], sys.argv[4])
  output = grader.grade()
  grader.cleanup()

# call
if __name__ == "__main__":
      main()
