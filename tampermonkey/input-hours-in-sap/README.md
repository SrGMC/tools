# Input hours in SAP

A script to automatically input workhours in SAP's timesheet management system

## How to install

1. Install https://www.tampermonkey.net/ in your browser
2. Download [script.js](./script.js) to your local machine
3. In the browser, open the Tampermonkey extension and click on _Create a new script..._
4. Copy and paste the contents of [script.js](./script.js) into the script creation tab
5. Click on _File_ > _Save_

## How to use

1. Modify the [script.js](./script.js) file to set your parameters
   - Set the `TEAM` variable to the name of your team as it appears in the SAP TimeSheet dropddown
   - Set the working hours in the `TIMEHSEET` variable
2. Open SAP and go to the [Timesheet page](https://performancemanager.successfactors.eu/sf/timesheet)
3. Click on the _Fill timesheet_ button on the bottom left corner
   - Days that have been already been filled, or that have the `noWork: true` parameter will be skipped
   - Days that have 0 hr 00 min of suggested worktime will be skipped
4. Review that the timesheet is filled correctly and click on _Submit_ to submit your timesheet to HR

You can use other windows in your computer while the timesheet is filled. Do not close the tab until the process finishes.
