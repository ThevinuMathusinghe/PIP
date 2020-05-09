var links = document.querySelectorAll('.column-2');
var linksArray = Array.from(links);

linksArray = linksArray.filter((link, i) => {
  return i != 0;
});

linksArray = linksArray.map((link) => {
  return link.childNodes[0].href;
});
