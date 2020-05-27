//Links
let links = document.querySelectorAll("li span a");
let linksArray = Array.from(links);
var linkClassArray = [];

for (var i = 3; i < 35; i++) {
  linkClassArray.push(linksArray[i].href);
}
console.log(linkClassArray);

//Page 2 Links
let links = document.querySelectorAll("div.a-text-center li.a-last");
let linksArray = Array.from(links);
var linkClassArray = [];
var linksData = [];
for (var i = 0; i < linksArray.length; i++) {
  var linksArray2 = Array.from(linksArray[i].childNodes);
  for (var j = 0; j < linksArray2.length; j++) {
    if (linksArray2[j].nodeName == "A") {
      linksData.push(linksArray2[j].href);
    }
  }
}
console.log(linksData);

/////////////////////////////////////////////////

let div = document.querySelectorAll("div.sg-col-inner");
let divArray = Array.from(div);
var divClassArray = [];
var titleArray = [];
for (var i = 7; i < divArray.length; i += 8) {
  divClassArray.push(divArray[i].childNodes[1]);
}
console.log(divClassArray);

//BOOK INFO
let div = document.querySelectorAll("div.sg-col-inner");
let divArray = Array.from(div);
var dateArray = [];
var titleArray = [];
var authorArray = [];
var ratingArray = [];
var linkArray = [];
for (var i = 7; i < divArray.length; i += 8) {
  ///DATE///////////////////////////////////////////////////////////////////////////
  if (
    divArray[i].childNodes[1] == undefined ||
    divArray[i].childNodes[1].childNodes[3] == undefined
  ) {
    dateArray.push("");
  } else {
    if (
      divArray[i].childNodes[1].childNodes[3].childNodes.length >= 5 &&
      divArray[i].childNodes[1].childNodes[3].childNodes[
        divArray[i].childNodes[1].childNodes[3].childNodes.length - 1
      ].className == "a-size-base a-color-secondary a-text-normal"
    ) {
      dateArray.push(
        divArray[i].childNodes[1].childNodes[3].childNodes[
          divArray[i].childNodes[1].childNodes[3].childNodes.length - 1
        ].innerText
      );
    } else {
      dateArray.push("");
    }
  }
  ///AUTHOR///////////////////////////////////////////////////////////////////////////
  if (
    divArray[i].childNodes[1] == undefined ||
    divArray[i].childNodes[1].childNodes[3] == undefined ||
    divArray[i].childNodes[1].childNodes[3].childNodes[1] == undefined
  ) {
    authorArray.push("");
  } else {
    if (
      divArray[i].childNodes[1].childNodes[3].childNodes[1].className ==
      "a-size-base"
    ) {
      authorArray.push(
        divArray[i].childNodes[1].childNodes[3].childNodes[1].innerText
      );
    } else if (
      divArray[i].childNodes[1].childNodes[3].childNodes[2].className ==
      "a-size-base a-link-normal"
    ) {
      authorArray.push(
        divArray[i].childNodes[1].childNodes[3].childNodes[2].innerText
      );
    }
  }

  ////TITLE//////////////////////////////////////////////////////////////////////////
  titleArray.push(divArray[i].childNodes[1].childNodes[1].outerText);

  ///RATING///////////////////////////////////////////////////////////////////////////
  if (
    divArray[i].childNodes[3] == undefined ||
    divArray[i].childNodes[3].childNodes[1] == undefined ||
    divArray[i].childNodes[3].childNodes[1].childNodes[1] == undefined
  ) {
    ratingArray.push("");
  } else {
    ratingArray.push(
      divArray[i].childNodes[3].childNodes[1].childNodes[1].ariaLabel
    );
  }

  ///LINKS///////////////////////////////////////////////////////////////////////
  linkArray.push(divArray[i].childNodes[1].childNodes[1].childNodes[1].href);
}

///IMAGE//////////////////////////////////////////////////////////////////////////
let image = document.querySelectorAll("div.a-section");
let imageArray = Array.from(image);
var imageClassArray = [];
for (var i = 1; i < imageArray.length; i++) {
  if (
    imageArray[i].className == "a-section aok-relative s-image-fixed-height"
  ) {
    imageClassArray.push(imageArray[i].childNodes[1].currentSrc);
  }
}
console.log(titleArray);
console.log(authorArray);
console.log(dateArray);
console.log(ratingArray);
console.log(imageClassArray);
console.log(linkArray);

// let links = document.querySelectorAll("div.pagnHy");
// let linksArray = Array.from(links);
// var linkClassArray = [];

// var informationDetailsDataArray = [];

// for (var i = 0; i < linkClassArray.length; i++) {
//   var detailesChildNodeArray = Array.from( linkClassArray[i].childNodes );
//   for (var j = 0; j < detailesChildNodeArray.length; j++) {
//     informationDetailsDataArray.push(detailesChildNodeArray[j].className == "pagnLink");

// console.log(informationDetailsDataArray);

//Title
var title = document.querySelectorAll("h1")[0].innerText;
console.log(title);

//Description
var description = document.querySelectorAll("div.ci-content-fullwidth p");
var descriptionArray = Array.from(description);
var descriptionString = descriptionArray[1].innerText;
console.log(descriptionString);

//Revenue
var revenue = document.querySelectorAll("td");
var revenueArray = Array.from(revenue);
var revenueData = "";
for (var i = 0; i < revenueArray.length; i++) {
  if (revenueArray[i].innerText == "Revenue") {
    revenueData = revenueArray[i + 1].innerText;
  }
}
console.log(revenueData);

//PhoneNumber
var phoneNumber = document.querySelectorAll("td");
var phoneNumberArray = Array.from(phoneNumber);
var phoneNumberData = "";
for (var i = 0; i < phoneNumberArray.length; i++) {
  if (
    phoneNumberArray[i].innerText == "Phone" ||
    phoneNumberArray[i].innerText == "Freecall"
  ) {
    phoneNumberData = phoneNumberArray[i + 1].innerText;
  }
}
console.log(phoneNumberData);

//Website
var website = document.querySelectorAll("td");
var websiteArray = Array.from(website);
var websiteData = "";
for (var i = 0; i < websiteArray.length; i++) {
  if (websiteArray[i].innerText == "Website") {
    websiteData = websiteArray[i + 1].innerText;
  }
}
console.log(websiteData);

//INFORMATION

//Title & Details
var informationTitle = document.querySelectorAll("tr");
var informationTitleArray = Array.from(informationTitle);
var informationTitleDataArray = [];
for (var i = 0; i < informationTitleArray.length; i++) {
  var childNodeArray = Array.from(informationTitleArray[i].childNodes);
  for (var j = 0; j < childNodeArray.length; j++) {
    if (childNodeArray[j].nodeName == "TD") {
      if (
        childNodeArray[j].childNodes.length > 0 &&
        childNodeArray[j].childNodes[0].nodeName == "IMG"
      ) {
        if (j + 2 < childNodeArray.length) {
          informationTitleDataArray.push(
            childNodeArray[j + 2].childNodes[0].innerText
          );

          childNodeArray[j + 2].childNodes[0].click();
        }
      }
    }
  }
}
//Rating
var informationDetails = document.querySelectorAll("td.smallerFont");
var informationDetailsArray = Array.from(informationDetails);
var informationDetailsDataArray = [];
var ratingArray = [];
for (var i = 0; i < informationDetailsArray.length; i++) {
  var detailesChildNodeArray = Array.from(
    informationDetailsArray[i].childNodes
  );
  for (var j = 3; j < detailesChildNodeArray.length; j += 4) {
    informationDetailsDataArray.push(detailesChildNodeArray[j].innerText);
    if (informationDetailsArray[i].className == "smallerFont companyPraise") {
      ratingArray.push("praise");
    } else if (
      informationDetailsArray[i].className == "smallerFont companyCriticism"
    ) {
      ratingArray.push("criticism");
    } else {
      ratingArray.push("information");
    }
  }
}
console.log(informationDetailsDataArray);
console.log(ratingArray);
console.log(informationTitleDataArray);

//Address
var address = document.querySelectorAll("td");
var addressArray = Array.from(address);
var addressData = "";
for (var i = 0; i < addressArray.length; i++) {
  if (addressArray[i].innerText == "Address") {
    addressData = addressArray[i + 1].innerText;
  }
}
console.log(addressData);

var links = document.querySelectorAll(".column-2");
var linksArray = Array.from(links);

linksArray = linksArray.filter((link, i) => {
  return i != 0;
});

var linksData = [];
for (var i = 0; i < linksArray.length; i++) {
  var linksArray2 = Array.from(linksArray[i].childNodes);
  for (var j = 0; j < linksArray2.length; j++) {
    if (linksArray2[j].nodeName == "A") {
      linksData.push(linksArray2[j].href);
    }
  }
}

console.log(linksData);
