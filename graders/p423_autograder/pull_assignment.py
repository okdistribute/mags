#!/usr/local/bin/python3
import sys
import os
import subprocess
import smtplib
from email.mime.text import MIMEText
from email.utils import COMMASPACE


class AssignmentPuller:
  """
  AUTHOR: Christopher Zakian | czakian@indiana.edu

  The AssigmnentPuller class recursively pulls down
  github repositories from a roster and then checks out
  an assignment branch and then grabs the github commit
  hash from the HEAD of that branch. 
  
  """

  def __init__(self, assignment, usernames):
    """
    Initialize this object.

    ARGS:
    assignment: the assignment name. This must
    correspond to the branch that the student is
    using for their development.

    usernames: a roster of usernames which are attached
    to the student's p423 repository

    RETURNS: this object.

    """
    self.assignment = assignment
    self.usernames = usernames
    self.hashes = []
    self.failed_hashes = []

  def pull_assignment(self):
    """
    Pulls all the student's repositories in the usernames
    found in the usernames file given at initialization.
    The successfull username/hash lines are written to a file
    under <current-dir>/<assignment>/student_hashes_<assignment>.txt.

    If for some reason a student's repository cannot be pulled, that 
    username is written to a file located at:
    <current-dir>/<assignment>/failed_pull_<assignment>.txt.

    RETURNS: a filename with the location of the username/hash associations.

    """
    hash = None
    cwd = os.getcwd()
  
  
    # reset the seek. We may have already read the file once, or partially.
    self.usernames.seek(0)

    # pull each repository and write its hash out 
    for username in self.usernames:
      username = username.strip()
      os.system("git clone git@github.iu.edu:p423-523-sp13/"+username+".git > /dev/null 2>&1")
      os.system("git checkout " + self.assignment+ " > /dev/null 2>&1")
      os.chdir(username)
  
      # grab the revision from HEAD
      p = subprocess.Popen(
             ["git", "rev-parse", "HEAD"], 
             stdout=subprocess.PIPE, 
             stderr=subprocess.PIPE, 
             stdin=subprocess.PIPE
          )
      
      try:
        while p.poll() == None:
          hash = p.stdout.readline().decode("utf-8")
  
          # HEAD is returned if this is an empty repostory that has not 
          # been submitted to.
          if not hash:
            raise RuntimeException("ERROR: could not get hash for student: " + username)

          res = username+"/"+hash
          self.hashes.append(res)
      except:
         self.failed_hashes.append(username+"\n")
  
      os.chdir(cwd)
  
    return self.hashes

  def notify_of_pull(self,recipients):
    success = "".join(self.hashes)
    failed  = "".join(self.failed_hashes)
    msg_body = "This is an automatically generated message and is for safety backups only.\n"
    msg_body += "--------- GOT HASHES FROM ------------\n"
    msg_body += success
    msg_body += "---------FAILED TO GET FROM ------------"
    msg_body += failed

    msg = MIMEText(msg_body)

    sender = 'p423@cs.indiana.edu'
    msg['Subject'] = 'P423 pulled assignment: %s' % self.assignment
    msg['From'] = sender
    msg['To'] = COMMASPACE.join(recipients)

    smtp = smtplib.SMTP('cs.indiana.edu')
    smtp.sendmail(sender, recipients, msg.as_string())


  def delete_repos(self):
    """
    Convenience method.
    Delete all the repositories we pull.

    RETURNS: None
    """
    self.usernames.seek(0)
    for username in self.usernames:
      os.system("rm -rf "+username)
  
def main():
  """
  a test of the assignment puller 
  """

  if len(sys.argv) <= 2:
    print("Too few arguments. Usage: <assignment-name> <file-of-usernames>")
    sys.exit()

  assignment = sys.argv[1]
  usernames  = open(sys.argv[2])
  recipients = ['czakian@indiana.edu','relarson@indiana.edu', 'awhsu@indiana.edu', 'rrnewton@indiana.edu']
  puller = AssignmentPuller(assignment,usernames)
  puller.delete_repos()
  puller.pull_assignment()
  print("--------- GOT HASHES FROM ------------")
  for hash in puller.hashes:
    print(hash)
  print("---------FAILED TO GET FROM ------------")
  for hash in puller.failed_hashes:
    print(hash)
  if len(sys.argv) > 3 and sys.argv[3] == '--notify':
    puller.notify_of_pull(recipients)
  puller.delete_repos()
  

# call
if __name__ == "__main__":
      main()



      


    
