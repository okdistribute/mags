#!/bin/python3
import sys
import os
import shutil
import subprocess


class P423Grader:

  def __init__(self, solution_hash, student_info, options=None, cmd="test"):

    username,student_hash = student_info.split("/")
    repo = "p423-523-sp13"

    self.options = options
    self.sdir = "Compiler"
    self.username = username
    self.framework = "framework-private"
    self.cmd = cmd

    cwd = os.getcwd()
    os.system("git clone git@github.iu.edu:"+repo+"/"+username+".git")
    os.chdir(username)
    os.system("git checkout " + student_hash)
    os.chdir(cwd)

    os.system("git clone git@github.iu.edu:"+repo+"/"+self.framework+".git")
    os.chdir(self.framework)
    os.system("git checkout " + solution_hash)
    os.chdir(cwd)


  def grade(self):
    if self.options == "all":
      self.__do_grade_all()
    elif self.options:
      self.__do_grade_single()
    else:
      raise RuntimeError("bad option passed in from the user. Allowable options are: all,single,both")

  def __do_grade_all(self):
    cwd = os.getcwd()
    src = cwd+"/"+self.username+"/"+self.sdir
    dest = cwd+"/"+self.framework

    if os.path.exists(dest):
      shutil.rmtree(dest)
    shutil.copytree(src, dest)

    os.chdir(cwd+"/"+self.framework)
    p = subprocess.Popen(["make", self.cmd], stdout=subprocess.PIPE)
    result_xml = p.communicate()
    os.chdir(cwd)
    return result_xml

  def __do_grade_single():
    cwd = os.getcwd()
    shutil.copy2(cwd+"/"+self.username+"/"+self.sdir+"/"+self.options, cwd+"/"+self.framework)
    os.chdir(cwd+"/"+self.framework)
    p = subprocess.Popen(["make", self.cmd], stdout=subprocess.PIPE)
    result_xml = p.communicate()
    os.chdir(cwd)
    return result_xml

  def cleanup(self):
    os.system("rm -rf framework-private")
    os.system("rm -rf "+self.username)

    

def main():

  if len(sys.argv) < 3:
    raise RuntimeError(
      """invalid number of arguments. 
         Usage: <solution hash> <username/student_hash> <all|single-pass-name> [<test|scheme|haskell>])
      """)
  grader = P423Grader(sys.argv[1],sys.argv[2],sys.argv[3], sys.argv[4])
  output = grader.grade()
  grader.cleanup()
  print(output)

main()
    







