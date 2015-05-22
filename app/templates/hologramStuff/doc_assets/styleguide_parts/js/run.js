// 参考:
// https://app.codegrid.net/entry/web-components-3
// http://www.html5rocks.com/ja/tutorials/webcomponents/customelements/
// http://www.html5rocks.com/ja/tutorials/webcomponents/shadowdom/
// https://developer.mozilla.org/en-US/docs/Web/API/Document/registerElement
(function () {
    "use strict";
    var examples = document.querySelectorAll(".codeExample");

    document.registerElement("x-sg-output-example");

    Array.prototype.forEach.call(examples, function (example, index) {
        var appendTarget = example.querySelector(".exampleOutput");
        var customElement = document.createElement("x-sg-output-example");
        var shadowRoot;
        var template = example.querySelector(".renderedExampleTmpl");
        var clone;

        shadowRoot = customElement.createShadowRoot();
        clone = document.importNode(template.content, true);
        shadowRoot.appendChild(clone);
        appendTarget.appendChild(customElement);
    });
}());
