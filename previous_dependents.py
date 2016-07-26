
import os
import sys
import commands
import string
import datetime
import time
import sched  
import threading
import platform
import operator
import urllib

path = os.getenv('path')

path = path + ";%ACE_ROOT%/lib"

print path