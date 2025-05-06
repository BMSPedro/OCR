var pdfDoc = null,
    pageNum = 1,
    pageRendering = false,
    pageNumPending = null,
    IsFirstLoad = true;

function InitializeControl(controlId) {
    var controlAddIn = document.getElementById(controlId);
    controlAddIn.innerHTML ='<div id="pdf-contents"><div id="pdf-meta"><div id="pdf-buttons"><button id="prev">Previous</button><button id="next">Next</button><button id="pdf-view">View</button></div><span id="page-count-container">Page: <span id="page_num"></span> / <span id="page_count"></span></span></div><canvas id="the-canvas"></canvas></div>';
}

function SetVisible(IsVisible) {
    if (IsVisible){
        document.querySelector("#pdf-contents").style.display = 'block';
    }else{
        document.querySelector("#pdf-contents").style.display = 'none';
    }

}

function LoadPDF(PDFDocument,IsFactbox){
    
    var canvas = document.getElementById('the-canvas'),
    pdfcontents = document.getElementById('pdf-contents'),
    ctx = canvas.getContext('2d'),
    iframe = window.frameElement,
    factboxarea = window.frameElement.parentElement.parentElement.parentElement.parentElement.parentElement.parentElement.parentElement.parentElement,
    scale = 1.3;


    pageRendering = false;
    pageNum = 1;
    pageNumPending = null;

    PDFDocument = atob(PDFDocument);

    if (IsFactbox) {
        if (factboxarea.className = "ms-nav-layout-factbox-content-area ms-nav-scrollable"){
            factboxarea.style.paddingLeft = "1px";
            factboxarea.style.paddingRight = "1px";
            factboxarea.style.overflowY = "scroll";
        }
        scale = 0.55;
        }else{
            document.querySelector("#pdf-view").style.display = 'none';
        }
    

    requestAnimationFrame(() => {
        
        /**
           @param num 
         */
        function renderPage(num) {
            pageRendering = true;
          
            pdfDoc.getPage(num).then(function(page) {
            var viewport = page.getViewport({scale: scale});
            canvas.height = viewport.height;
            canvas.width = viewport.width;

            pdfcontents.height = viewport.height;
            pdfcontents.width = viewport.width;
            iframe.style.height = viewport.height + 100 + "px";
            iframe.parentElement.style.height = viewport.height + 100 + "px";
            iframe.style.maxHeight = "2500px";

            var renderContext = {
                canvasContext: ctx,
                viewport: viewport
            };
            var renderTask = page.render(renderContext);
        
            renderTask.promise.then(function() {
                pageRendering = false;
                if (pageNumPending !== null) {
              
                renderPage(pageNumPending);
                pageNumPending = null;
                }
            });
            });
        
            document.getElementById('page_num').textContent = num;
        }

        function queueRenderPage(num) {
            if (pageRendering) {
            pageNumPending = num;
            } else {
            renderPage(num);
            }
        }

        function onPrevPage() {
            if (pageNum <= 1) {
            return;
            }
            pageNum--;
            queueRenderPage(pageNum);
        }
        if (IsFirstLoad){
            document.getElementById('prev').addEventListener('click', onPrevPage);
        }

        function onNextPage() {
            if (pageNum >= pdfDoc.numPages) {
            return;
            }
            pageNum++;
            queueRenderPage(pageNum);
        }
        if (IsFirstLoad){
            document.getElementById('next').addEventListener('click', onNextPage);
        }

        function onView() {
            Microsoft.Dynamics.NAV.InvokeExtensibilityMethod('onView');
        }
        if (IsFirstLoad){
            document.getElementById('pdf-view').addEventListener('click', onView);
        }

        IsFirstLoad = false;

        pdfjsLib.getDocument({data: PDFDocument}).promise.then(function(pdfDoc_) {
            pdfDoc = pdfDoc_;
            document.getElementById('page_count').textContent = pdfDoc.numPages;
        
            renderPage(pageNum);
        });
    });
}