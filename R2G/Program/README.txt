Developed by Doug Totten 7/10/2018
Developed and tested on matlab version 9.1.0.441655 (R2016b)

------ WARNING ------ 
rotating the well-plate the wrong direction can break the bottom flaps off of the wells. The first time running this program I recommend doing it without wells inserted into the well-plate, to verify that everything is wired appropriately. 
---------------------


------ Setting up programs ------

-Before the first run, set the communication channels for each of the arduinos in the R2G_Wrap.m function. E.g.:

R2G_Initialize_Arduino_CapSense ('COM8');
Initialize_Arduino_Cameras ('COM6');
Initialize_Arduino_TB6600_Stepper('COM7');

-To change the directory that task data gets saved to, modify the R2G_Initialize_Storage.m function


------ Running R2G Task ------

-ALWAYS start with the blocker in the open position. 
-Use the CO_Interface.m function to control the device
-Name - subjects name. Effects saved directory
-Reps - how many times each target is presented
Hold min - minimum hold-time in ms
Hold max - maximum hold-time in ms
Trial time - how long subject has to retrieve reward from window
Punish time - used to give subject a time-out if they do not satisfy the hold-requirement
Motors On - activates the motor that runs the blocker

Start - start the task
Stop - stop the task
Adjust Motor - if the blocker comes out of alignment, this allows you to pause the blocker and adjust its position


------ MATLAB FUNCTIONS ------ 
R2G_Interface - GUI to run the center-out program
