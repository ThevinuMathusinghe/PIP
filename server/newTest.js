var subCategories = document.querySelectorAll(
  '.a-unordered-list.a-nostyle.a-vertical'
);
subCategories = Array.from(subCategories);

var links = Array.from(
  subCategories[1].childNodes[2].childNodes[0].childNodes
).map((li) => {
  return li.childNodes[0].childNodes[0].href;
});

console.log(links);

// get all the ui
var subCategories = document.querySelectorAll(
  '.a-unordered-list.a-nostyle.a-vertical'
);
subCategories = Array.from(subCategories);

var categoryName = document.querySelector('h1').innerText;
categoryName = categoryName.replace('Books', '');
categoryName = categoryName.trim();

// Find the one with the name in
var index = 0;
subCategories.forEach((sub, i) => {
  if (sub.childNodes.length > 2) {
    var one = sub.childNodes[1];
    if (one.childNodes.length >= 1) {
      if (one.childNodes[0].innerText == "Children's Books") {
        index = i;
      }
    }
  }
});

var links = [];
subCategories[index].childNodes[2].childNodes[0].childNodes.forEach((li) => {
  links.push(li.childNodes[0].childNodes[0].href);
});

// Once matched get all the links

var nextPageLink = document.querySelector('#pagnNextLink').href;
console.log(nextPageLink);
