var categoriesTxt;
var transactionsTxt;

var categories = [];
var transactions = [];
var colors = ['blue', 'green', 'orange', 'red', 'purple', 'teal', 'yellow', 'indigo', 'pink'];

var balance = 0;
var spent = 0;
var limit = 0;

var displayDate = new Date();

function getRequest(url, resolve, reject) {
  var xhr = new XMLHttpRequest();
  xhr.open('GET', url);
  xhr.onload = function () {
    if(xhr.status !== 200 || xhr.readyState !== 4) {
        reject(xhr.response);
        return;
    }
    resolve(xhr.response);
  };
  xhr.onerror = function () {
    reject(xhr.response);
  };
  xhr.send();
}

function resolveColor(string) {
    var count = 0;
    for (let i = 0; i < string.length; i++) {
        count += string.charCodeAt(i);
    }
    return colors[count % colors.length];
}

function resolveCategory(string) {
    for (let i = 0; i < categories.length; i++) {
        if(categories[i].name === string) return i;
    }
    return -1;
}

function getPercentage(current, max) {
    current = Math.abs(current);
    max = Math.abs(max);
    if(current === 0) {
        return 0;
    }
    if(max < current) {
        return 100;
    }
    
    return current/max * 100;
}

function computeValues() {
    spent = 0;
    for (let i = 0; i < categories.length; i++) {
        categories[i].current = 0;
    }
    for (let i = 0; i < transactions.length; i++) {
        var cat = transactions[i].category;
        var value = transactions[i].value;
        var date = transactions[i].date;
        
        if(date.getFullYear() === displayDate.getFullYear() && date.getMonth() === displayDate.getMonth()) {
            categories[cat].current += value;
            spent += value < 0 ? value : 0;
        }
    }
}

function parseCategories() {
    var cat = categoriesTxt.split('\n').filter(function (el) {
        return el != "";
    });
    for (let i = 0; i < cat.length; i++) {
        var line = cat[i].split(',');
        limit += parseFloat(line[1].trim());
        categories.push({"name": line[0].trim(), "limit": parseFloat(line[1].trim()), "current": 0});
    }
}

function parseTransactions() {
    var trans = transactionsTxt.split('\n').filter(function (el) {
        return el != "";
    });
    for (let i = trans.length - 1; i >= 0; i--) {
        var line = trans[i].split(',');
        var cat = resolveCategory(line[2].trim());
        var value = parseFloat(line[3].trim());
        var date = new Date(line[0].trim());
        transactions.push({"date": date, "name": line[1].trim(), "category": cat, "value": value});
        balance += value;
        
        if(date.getFullYear() === displayDate.getFullYear() && date.getMonth() === displayDate.getMonth()) {
            categories[cat].current += value;
            spent += value < 0 ? value : 0;
        }
    }
}

function displayCategories() {
    var container = document.querySelector('#catList');
    container.innerHTML = "";
    for (let i = 0; i < categories.length; i++) {
        container.innerHTML += '<div class="item">' + 
                                    '<div class="content">' + 
                                        '<span class="title">' + categories[i].name + '</span>' + 
                                        '<span class="right">' + categories[i].current.toFixed(2) + ' € / ' + categories[i].limit.toFixed(2) + ' €</span>' + 
                                        '<div class="bar">' + 
                                            '<div class="fill ' + resolveColor(categories[i].name) + '" style="width: ' + getPercentage(categories[i].current, categories[i].limit) + '%;"></div>' + 
                                        '</div>' + 
                                    '</div>' + 
                                '</div>';
    }
}

function displayTransactions() {
    var container = document.querySelector('#transList');
    container.innerHTML = "";
    for (let i = 0; i < transactions.length; i++) {
        var date = transactions[i].date.toISOString().split('T')[0].replace(/-/g, '/');
        container.innerHTML += '<div class="item">' + 
                                    '<div class="content">' + 
                                        '<span class="title">' + transactions[i].name + '</span>' + 
                                        '<span class="right">' + transactions[i].value.toFixed(2) + ' €</span>' + 
                                        '<span class="subtitle">' + date + ' - ' + categories[transactions[i].category].name + '</span>' +
                                    '</div>' + 
                                '</div>';
    }
}

function displayData() {
    document.querySelector('#balance').innerHTML = balance.toFixed(2) + " €";
    document.querySelector('#spent').innerHTML = Math.abs(spent.toFixed(2)) + " €";
    document.querySelector('#limit').innerHTML = limit.toFixed(2) + " €";
    document.querySelector('#bar').style.width = getPercentage(spent, limit) + "%";
    let months = ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'];
    document.querySelector('#date').innerHTML = months[displayDate.getMonth()] + ' ' + displayDate.getFullYear();
}

// When the user scrolls down 50px from the top of the document, resize the header's font size
window.onscroll = function() {scrollFunction()};

function scrollFunction() {
    if (document.body.scrollTop > 50 || document.documentElement.scrollTop > 50) {
        document.getElementById("header").classList.add("small");
    } else {
        document.getElementById("header").classList.remove("small");
    }
}

function toggleTransactions() {
    var container = document.querySelector("#transList");
    if (container.classList.contains('short')) {
        container.classList.remove('short');
    } else {
        container.classList.add('short');
    }
}

function changeDisplayDate(element) {
    displayDate = element.value == "" ? new Date() : new Date(element.value);
    computeValues();
    displayCategories();
    displayData();
}

function loadApp() {
    parseCategories();
    parseTransactions();
    displayTransactions();
    displayCategories();
    displayData();
}

getRequest('transactions.txt', function(transactions) {
    transactionsTxt = transactions;
    getRequest('categories.txt', function(categories) {
        categoriesTxt = categories;
        loadApp();
    }, function(data) {
        alert("Error fetching categories");
    });
}, function(data) {
    alert("Error fetching transactions");
});
