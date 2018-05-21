var GetURL = function() {};
GetURL.prototype = {
run: function(arguments) {
    var el = document.body;
    var text = el.innerText || el.textContent;
    arguments.completionFunction({"URL": document.URL, "Text": text});
}
};
var ExtensionPreprocessingJS = new GetURL;
