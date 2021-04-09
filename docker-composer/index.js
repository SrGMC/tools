// 
// docker-composer
// Tool to organize and sort `docker-compose.yaml` files
// 
// Author: Álvaro Galisteo (https://alvaro.galisteo.me)
// Copyright 2020 - GPLv3

const YAML = require("yaml");
const fs = require("fs");

// Argument parser
function help() {
    console.log("Usage: node index.js -h <file>");
    console.log("  <file>         File to format");
    console.log("");
    console.log("Optional arguments");
    console.log("  -h, --help     Display this help");
}

let args = process.argv.slice(2);
if (args[0] == null || args[0] == undefined) {
    help();
    console.log("\nError: No file was provided");
    process.exit(1);
}

for (let i = 0; i < args.length; i++) {
    if(args[i] == '-h' || args[i] == '--help') {
        help();
        process.exit(0);
    }   
}

/**
 * Given a key, returns the order in which the key should be sorted
 * @param key Key value 
 */
function sortKey(key) {
    switch (key) {
        case "image":
            return 0;
        case "container_name":
            return 1;
        case "depends_on":
            return 2;
        case "network_mode":
            return 3;
        case "networks":
            return 4;
        case "env_file":
            return 5;
        case "environment":
            return 6;
        case "working_dir":
            return 7;
        case "volumes":
            return 8;
        case "labels":
            return 9;
        case "ports":
            return 10;
        case "command":
            return 12;
        case "restart":
            return 13;
        default:
            return 11;
    }
}

/**
 * Given a YAML Document, sorts the services' keys
 * @param composeFile YAML Document
 */
function sortServices(composeFile) {
    for (let i = 0; i < composeFile.contents.items.length; i++) {
        if (composeFile.contents.items[i].key.value == "services") {
            for (let j = 0; j < composeFile.contents.items[i].value.items.length; j++) {
                composeFile.contents.items[i].value.items[j].value.items.sort((a, b) => {
                    return sortKey(a.key.value) - sortKey(b.key.value);
                });
            }
        }
    }
}

// Main program
fs.readFile(args[0], "utf8", function (err, data) {
    if (err) {
        throw err;
    }
    var composeFile = YAML.parseDocument(data);
    sortServices(composeFile);
    console.log(composeFile.toString().replace(/\\\n\s+/g, ''));
});
