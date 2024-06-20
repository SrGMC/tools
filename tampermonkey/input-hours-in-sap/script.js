// ==UserScript==
// @name         Input hours in SAP
// @namespace    http://tampermonkey.net/
// @version      2024-06-19
// @description  A script to automatically input workhours in SAP's timesheet management system
// @author       Álvaro Galisteo
// @match        https://performancemanager.successfactors.eu/sf/timesheet*
// @icon         https://cdn.iconscout.com/icon/free/png-256/free-sap-3629036-3030393.png
// @grant        none
// ==/UserScript==

const TEAM = "DOTREZ";
const TIMESHEET = {
    monday: { start: "08:30", end: "17:30", lunch: "00:45" },
    tuesday: { start: "08:30", end: "17:30", lunch: "00:45" },
    wednesday: { start: "08:30", end: "17:30", lunch: "00:45" },
    thursday: { start: "08:30", end: "17:30", lunch: "00:45" },
    friday: { start: "08:00", end: "15:00", lunch: "00:00" },
    saturday: { noWork: true },
    sunday: { noWork: true },
};

let filling = false;

function getYear() {
    // Get year from H1 with id __component2---timeSheetSummaryView--timeSheetSummaryTitle
    // Format of the text inside the H1 is in the format Time Sheet for Jun 17 – 23, 2024
    const h1 = document.getElementById("__component2---timeSheetSummaryView--timeSheetSummaryTitle");
    const text = h1.innerText;
    const year = text.split(", ")[1];
    return parseInt(year);
}

async function wait(ms) {
    return new Promise((resolve) => {
        setTimeout(resolve, ms);
    });
}

async function waitForElement(query, parent = document, action = 'appear') {
    return new Promise((resolve) => {
        const interval = setInterval(() => {
            console.log(`Waiting for element ${query}`);
            const element = parent.querySelector(query);
            if (action === 'appear' && element) {
                clearInterval(interval);
                resolve(element);
            }

            if (action === 'disappear' && !element) {
                clearInterval(interval);
                resolve();
            }
        }, 100);
    });
}

function textTimeToHumanReadableString(time) {
    // Converts the time in the format 08:30 to 8 hr 30 min
    const timeParts = time.split(":");
    const hours = parseInt(timeParts[0]);
    const minutes = parseInt(timeParts[1]);

    // If hours is 0, don't display it
    if (hours == 0) {
        return `${minutes} min`;
    }

    return `${hours} hr ${minutes} min`;
}

function calculateWorkHours(weekdayName, string = false) {
    let weekday = TIMESHEET[weekdayName];

    if (weekday.noWork) {
        return '00:00';
    }

    let start = weekday.start.split(":");
    let end = weekday.end.split(":");
    let lunch = weekday.lunch.split(":");

    let startMinutes = parseInt(start[0]) * 60 + parseInt(start[1]);
    let endMinutes = parseInt(end[0]) * 60 + parseInt(end[1]);
    let lunchMinutes = parseInt(lunch[0]) * 60 + parseInt(lunch[1]);

    let workMinutes = endMinutes - startMinutes - lunchMinutes;
    let workHours = Math.floor(workMinutes / 60);
    let workRemainder = workMinutes % 60;

    if (string) {
        return `${workHours.toString().padStart(2, "0")}:${workRemainder.toString().padStart(2, "0")}`;
    } else {
        return workHours * 60 + workRemainder;
    }
}

class TimesheetDay {
    row;
    columns;
    date;
    weekdayName;
    plannedTime;
    recordedTime;

    constructor(row) {
        this.row = row;
        this.columns = row.querySelectorAll("td");

        this._parseDate();
        this._parsePlannedTime();
        this._parseRecordedTime();

        this.weekdayName = new Date(this.date).toLocaleDateString("en-US", { weekday: "long" }).toLowerCase();
    }

    _parseDate() {
        const months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"];

        // Date is in the second column of the tr
        // The text inside the column is in the format Wednesday, Jun 19\n(Today) if it is today
        // or Tuesday\nJun 18 if it is not today
        const dateText = this.columns[1].innerText;

        // Split the text by newline
        this.date = `${getYear()}-`;
        const dateTextParts = dateText.split("\n");
        if (dateTextParts[1].includes("Today")) {
            let dateParts = dateTextParts[0].split(" ");
            let month = months.indexOf(dateParts[1]) + 1;
            let day = dateParts[2];

            this.date += `${month.toString().padStart(2, "0")}-${day.padStart(2, "0")}`;
        } else {
            let dateParts = dateTextParts[1].split(" ");
            let month = months.indexOf(dateParts[0]) + 1;
            let day = dateParts[1];

            this.date += `${month.toString().padStart(2, "0")}-${day.padStart(2, "0")}`;
        }
    }

    _parseHours(td) {
        // td innerText has the following format: 8 hr\nEmphasized\nObject Number\n00 min\nEmphasized\nObject Number\n
        const timeText = td.innerText;

        // Split the text by newline
        const timeTextParts = timeText.split("\n").filter((part) => part.includes("hr") || part.includes("min"));

        // Get the hours and minutes
        const hours = parseInt(timeTextParts.find((part) => part.includes("hr")).replace(" hr", ""));
        const minutes = parseInt(timeTextParts.find((part) => part.includes("min")).replace(" min", ""));

        // Convert to minutes
        return hours * 60 + minutes;
    }

    _parsePlannedTime() {
        this.plannedTime = this._parseHours(this.columns[2]);
    }

    _parseRecordedTime() {
        this.recordedTime = this._parseHours(this.columns[3]);
    }

    async fillTimesheet() {
        // Click on row and open the sidebar
        simulateClick(this.row);
        let sidebar = await waitForElement("#__component2---timeRecordingView");

        // Click on Record working time button
        let recordWorkingTimeButton = sidebar.querySelector("#__component2---timeRecordingView--attendancesDuration--add");
        simulateClick(recordWorkingTimeButton);

        // Wait for time list to load and the Notes textfield to appear
        let item = await waitForElement("#__component2---timeRecordingView--attendancesDuration-0-content", sidebar);
        let notes = await waitForElement("textarea");

        // Fill in the values
        let inputs = item.querySelectorAll("input");

        this.fillTimeType(inputs[0]);
        this.fillDuration(inputs[1]);

        // If lunch is 00:00, skip adding lunch time
        if (TIMESHEET[this.weekdayName].lunch !== "00:00") {
            notes.value = `${TIMESHEET[this.weekdayName].start} - ${TIMESHEET[this.weekdayName].end} (${textTimeToHumanReadableString(TIMESHEET[this.weekdayName].lunch)} lunch)`;
        } else {
            notes.value = `${TIMESHEET[this.weekdayName].start} - ${TIMESHEET[this.weekdayName].end}`;
        }

        // Simulate click on sidebar #__component2---timeRecordingView--btnSaveTimeRecords
        await wait(2000);
        let saveButton = sidebar.querySelector("#__component2---timeRecordingView--btnSaveTimeRecords");
        simulateClick(saveButton);

        // Wait until #__component2---timeSheetSummaryView--busyDialog-Dialog-scrollCont appears then disappears
        await waitForElement("#__component2---timeSheetSummaryView--busyDialog-Dialog-scrollCont");
        await waitForElement("#__component2---timeSheetSummaryView--busyDialog-Dialog-scrollCont", document, 'disappear');
    }

    async fillTimeType(input) {
        // Find span at the end of the parent div
        let parent = input.parentElement;
        let arrow = parent.querySelector("span");

        // Click the arrow
        simulateClick(arrow);

        // Find the ul in .sapMPopover
        let ul = await waitForElement(".sapMPopover.sapMSuggestionsPopover.sapMComboBoxBasePicker ul");
        console.log(ul);

        // Find the li element that matches TEAM in its innerText and click it
        let li = Array.from(ul.querySelectorAll('li')).find((li) => li.innerText === TEAM);
        if (li) {
            simulateClick(li);
        } else {
            throw new Error(`Could not find ${TEAM} in the list of time types`);
        }
    }

    async fillDuration(input) {
        let weekday = new Date(this.date).toLocaleDateString("en-US", { weekday: "long" }).toLowerCase();
        let duration = calculateWorkHours(weekday, true);

        // Get the id of the input, without '-inner'suffix
        let id = input.id.replace("-inner", "");

        // Input the hours using SAP UI
        sap.ui.getCore().byFieldGroupId("").find((e) => e.sId == id).setValue(duration);
    }
}

function triggerMouseEvent(node, eventType) {
    var clickEvent = new Event(eventType, { bubbles: true, cancelable: true });
    node.dispatchEvent(clickEvent);
}

function simulateClick(node) {
    triggerMouseEvent(node, "mouseover");
    triggerMouseEvent(node, "mousedown");
    triggerMouseEvent(node, "mouseup");
    triggerMouseEvent(node, "click");
}

function triggerKeyboardEvent(node, eventType, key) {
    var keyboardEvent = new KeyboardEvent(eventType, { key: key });
    node.dispatchEvent(keyboardEvent);
}

function simulateKeypress(node, key) {
    triggerKeyboardEvent(node, "keydown", key);
    triggerKeyboardEvent(node, "keypress", key);
    triggerKeyboardEvent(node, "keyup", key);
}


async function fillTimesheet() {
    const weekdays = ["monday", "tuesday", "wednesday", "thursday", "friday", "saturday", "sunday"];
    // clickWeekday('thursday');

    const table = document.querySelector("table");
    const dayRows = table.querySelectorAll("tr");

    // Set TIMESHEET[day].row as a TimesheetDay object
    filling = true;
    for (let i = 1; i < dayRows.length; i++) {
        const dayRow = dayRows[i];
        const day = weekdays[i - 1];
        TIMESHEET[day].row = new TimesheetDay(dayRow);

        // If planned time is 0 or recorded time is not 0, skip the day
        if (TIMESHEET[day].row.plannedTime == 0 || TIMESHEET[day].row.recordedTime != 0) {
            console.log(`Skipping ${day}`);
            continue;
        }

        await TIMESHEET[day].row.fillTimesheet();
    }

    console.log("Timesheet parsed!");
    console.log(TIMESHEET);
    filling = false;
}

(function () {
    "use strict";

    // Create the button
    var btn = document.createElement("button");
    btn.innerHTML = "Fill timesheet";
    btn.style.position = "fixed";
    btn.style.bottom = "20px";
    btn.style.left = "20px";
    btn.style.padding = "10px 20px";
    btn.style.cursor = "pointer";
    btn.style.zIndex = "1000";

    // Append the button to the body
    document.body.appendChild(btn);

    // Add click event listener to the button
    btn.addEventListener("click", fillTimesheet);

    // Intercept XMLHttpRequests before they are sent
    (function(send) {
        XMLHttpRequest.prototype.send = function(data) {
            // If the request is to /odatav4/timemanagement/attendance/AttendanceRecordingUi.svc/v2/$batch and has data
            // change "durationInMinutes":"XXX" to "durationInMinutes":"YYY"
            let newData;
            if (this._requestUrl.includes("/odatav4/timemanagement/attendance/AttendanceRecordingUi.svc/v2/$batch") && data && data.includes('POST TimeSheetSummary(') && filling) {
                console.log('Intercepted request');

                // Get date from the data, which is a string in the format of POST TimeSheetSummary(assignmentId='102667',shiftDate=<week start day>)/days(assignmentId='102667',shiftDate=<date>)/attendances
                // Find line with POST TimeSheetSummary(assignmentId='102667',shiftDate=<week start day>)/days(assignmentId='102667',shiftDate=<date>)/attendances
                let line = data.split("\n").find((line) => line.includes("POST TimeSheetSummary("));
                let lineSplit = line.split("/");
                let date = lineSplit[1].split("shiftDate=")[1].split(")")[0];
                let weekday = new Date(date).toLocaleDateString("en-US", { weekday: "long" }).toLowerCase();

                // If the weekday is in the TIMESHEET object
                // get the duration in minutes, which is end - start - lunch
                let duration = calculateWorkHours(weekday);
                console.log(`Calculated duration for ${weekday} (${date}): ${duration}`);
                console.log('Data', data);

                // Replace the durationInMinutes in the data
                newData = data.replace(/"durationInMinutes":"\d+"/, `"durationInMinutes":"${duration}"`);

                // Replace "attendanceTypeName":"${TEAM}" with "attendanceTypeName":"${TEAM}","cust_POL_creative_work":"<notes>"
                // If lunch is 00:00, skip adding lunch time
                let note = "";	
                if (TIMESHEET[weekday].lunch !== "00:00") {
                    note = `${TIMESHEET[weekday].start} - ${TIMESHEET[weekday].end} (${textTimeToHumanReadableString(TIMESHEET[weekday].lunch)} lunch)`;
                } else {
                    note = `${TIMESHEET[weekday].start} - ${TIMESHEET[weekday].end}`;
                }
                newData = newData.replace(`"attendanceTypeName":"${TEAM}"`, `"attendanceTypeName":"${TEAM}","cust_POL_creative_work":"${note}"`);

                // console.log('New data', newData);
            }

            send.call(this, newData || data);
        };
    })(XMLHttpRequest.prototype.send);
})();
