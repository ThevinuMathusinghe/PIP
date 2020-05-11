var title = document.querySelectorAll('h1')
console.log (title);

var description = document.querySelectorAll('div.ci-content-fullwidth p')
var descriptionArray = Array.from(description);
var descriptionString= descriptionArray[1].innerText;
console.log (descriptionString);


var revenue = document.querySelectorAll('td')
var revenueArray = Array.from(revenue);
var revenueData = "";
for (var i = 0; i < revenueArray.length; i++){
    if ( revenueArray[i].innerText == "Revenue"){
        v = revenueArray[i+1].innerText;
    }
}
console.log (revenueData);


var phoneNumber = document.querySelectorAll('td')
var phoneNumberArray = Array.from(phoneNumber);
var phoneNumberData = "";
for (var i = 0; i < phoneNumberArray.length; i++){
    if ( phoneNumberArray[i].innerText == "Phone" || phoneNumberArray[i].innerText == "Freecall"){
        phoneNumberData = phoneNumberArray[i+1].innerText;
    }
}
console.log (phoneNumberData);


var website = document.querySelectorAll('td')
var websiteArray = Array.from(website);
var websiteData = "";
for (var i = 0; i < websiteArray.length; i++){
    if (websiteArray[i].innerText == "Website"){
        websiteData = websiteArray[i+1].innerText;
    }
}
console.log (websiteData);

//INFORMATION

var informationTitle = document.querySelectorAll('div.boxCompanyInfo td a')
var informationTitleArray = Array.from(informationTitle);
var informationTitleDataArray = [];
for (var i = 0; i < informationTitleArray.length; i+=3){
    informationTitleDataArray.push(informationTitleArray[i].innerText)
}

console.log (informationTitleDataArray);

