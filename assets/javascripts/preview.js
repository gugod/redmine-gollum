/*jslint browser: true, windows: true, indent: 2 */
(function () {
  'use strict';

  function RedmineGollum() {
    this.preview = function preview(previewElementId, rawDataElementId, formatElementId, previewUrl) {
      var dataSrc, data_format, previewElement, params, self = this;
      dataSrc = document.getElementById(rawDataElementId).value;
      data_format = document.getElementById(formatElementId).value;
      previewElement = document.getElementById(previewElementId);

      previewElement.innerText = "loading...";
      // TODO tightly coupled with controller.
      params = "raw_data=" + encodeURIComponent(dataSrc) + "&page_format=" + data_format;
      this.loadXMLDoc("POST", previewUrl, params, function (data) { self.previewUpdate(data, previewElement); });
    };

    this.previewUpdate = function previewUpdate(data, preview) {
      preview.innerHTML = data;
    };

    this.loadXMLDoc = function loadXMLDoc(method, url, encoded_params, callback) {
      var xmlhttp;
      if (window.XMLHttpRequest) {// code for IE7+, Firefox, Chrome, Opera, Safari
        xmlhttp = new XMLHttpRequest();
      } else {// code for IE6, IE5
        xmlhttp = new ActiveXObject("Microsoft.XMLHTTP");
      }
      xmlhttp.onreadystatechange = function () {
        if (xmlhttp.readyState === 4 && xmlhttp.status === 200) {
          callback(xmlhttp.responseText);
        } else if (xmlhttp.readyState === 4) {
          callback("error occurred");
        }
      };
      xmlhttp.open(method, url, true);
      xmlhttp.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
      xmlhttp.setRequestHeader("Content-length", encoded_params.length);
      xmlhttp.setRequestHeader('X-CSRF-Token', this.getMetaCsrfToken());
      xmlhttp.send(encoded_params);
    };

    this.getMetaCsrfToken = function getMetaCsrfToken() {
      var metaElements, meta_csrf_token, metaIndex;
      metaElements = document.getElementsByTagName("meta");
      for (metaIndex in metaElements) {
        if (metaElements.hasOwnProperty(metaIndex)) {
          if (/^csrf-token$/i.test(metaElements[metaIndex].name)) {
            meta_csrf_token = metaElements[metaIndex].content;
          }
        }
      }
      return meta_csrf_token;
    };

  }

  window.RedmineGollum = new RedmineGollum();

}());

