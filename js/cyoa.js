const pages = document.querySelectorAll('.page');

function getPage(number) {
  for(const pageElement of pages) {
    if(+pageElement.dataset.pageNumber === number) {
      return pageElement;
    }
  }
}

for(const pageElement of pages) {
  pageElement.hidden = true;
  const choices = pageElement.querySelectorAll('.choice');
  for(const choiceElement of choices) {
    choiceElement.addEventListener('click', onClick);
    function onClick() {
      pageElement.hidden = true;
      getPage(+choiceElement.dataset.dest).hidden = false;
    }
  }
}

getPage(+document.body.dataset.start).hidden = false;
