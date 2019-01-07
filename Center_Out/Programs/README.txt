Developed by Doug Totten 7/10/2018
Developed and tested on matlab version 9.1.0.441655 (R2016b)

------ WARNING ------ 
the blocker is rotated by a stepper motor that does not have any positional limitations. However there is a limited range in which the blocker can spin. Attempting to drive the blocker past this point may damage it. 

ALWAYS start with the blocker in the open position. 

The first time you run the device, I recommend opening CO_Position_Blocker.m and setting move_distance=1 (line 9) instead of the standard move_distance=18. This will give you a 1-degree rotation that will let you test the device without damaging the blocker. 
---------------------


------ Setting up programs ------

-Before the first run, set the communication channels for each of the arduinos in the CO_Wrap.m function. E.g.:

CO_Initialize_Arduino_CapSense ('COM8');
Initialize_Arduino_Cameras ('COM6');
Initialize_Arduino_TB6600_Stepper('COM7');

-To change the directory that task data gets saved to, modify the CO_Initialize_Storage.m function


------ Running CO Task ------

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
CO_Interface - GUI to run the center-out program
CO_Blocker_Adjust - GUI that allows you to adjust blocker position
CO_Execute -