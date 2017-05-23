import sys
sys.path.append(r"c:\python25\lib")

import clr

#clr.AddReference("System.Windows.Forms")
#from System.Windows.Forms import SendKeys

clr.AddReference("SpeechFamiliar_Engine")
from SpeechFamiliar.Scripting import Automation

#clr.AddReference("EnvDTE90")
#clr.AddReference("EnvDTE")

#clr.AddReference("Microsoft.VisualBasic")
#from Microsoft.VisualBasic import Interaction

#import win32com.client
#vs = win32com.client.Dispatch("VisualStudio.DTE.8.0")
#vs = Interaction.CreateObject("VisualStudio.DTE.8.0")

#clr.AddReference("System.Speech.Recognition.SrgsGrammar")
#from System.Speech.Recognition.SrgsGrammar import *

from System import Array

def execute(name, parameters = None):
		if parameters == None:
			Automation.execute(name)
		else:
			Automation.execute(name, Array[object](parameters))