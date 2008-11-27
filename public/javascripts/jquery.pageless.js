// =======================================================================
// PageLess - endless page
//
// Author: Jean-Sébastien Ney (jeansebastien.ney@gmail.com)
//
// Parameters:
//    current_page: current page (params[:page])
//    distance: distance to the end of page in px when ajax query is fired
//    loader: selector of the loader div (ajax activity indicator)
//    loader_html: html code of the div if loader not used
//    loader_msg: displayed ajax message
//    pagination: selector of the paginator divs. (if javascript is disabled paginator is required)
//    params: paramaters for the ajax query, you can pass auth_token here
//    total_page: total number of pages
//    url: URL used to request more data
//
// Requires: jquery + jquery dimensions
//
// Thanks to:
//  * codemonky.com/post/34940898
//  * www.unspace.ca/discover/pageless/
//  * famspam.com/facebox
// =======================================================================

(function($) {
  $.pageless = function(settings) {
    $.isFunction(settings) ? settings.call() : $.pageless.init(settings)
  };
  
  // available params
  // loader: loading div
  // pagination: div selector for the pagination links
  // loader_msg:
  // loader_html:
  $.pageless.settings = {
    current_page: 1,
    pagination: '.pagination',
    params: {}, // params of the query you can pass auth_token here
    distance: 100, // page distance in px to the end when the ajax function is launch
    loader_html  : '\
  <div id="pageless_loader" style="display:none;text-align:center;width:100%;"> \
    <div class="msg" style="color:#e9e9e9;font-size:2em"></div>\
    <img src="/images/load.gif" title="load" alt="loading more results" style="margin: 10px auto" /> \
  </div>'
  };

  // settings params: total_pages
  $.pageless.init = function (settings) {
    if ($.pageless.settings.inited) return;
    
    $.pageless.settings.inited = true;
    
    if (settings) $.extend($.pageless.settings, settings);
    
    // remove pagination links since we have javascript enabled
    if($.pageless.settings.pagination)
      $($.pageless.settings.pagination).remove();
    
    // start the listener
    $.pageless.start_listener();
  };
  
  // init loader val
  $.pageless.is_loading = false;
  
  $.fn.pageless = function(settings) {
    $.pageless.init(settings);
    $.pageless.el = $(this);
    
    // loader element
    if(settings.loader && $(this).find(settings.loader).length){
      $.pageless.loader = $(this).find(settings.loader);
    } else {
      $(this).append($.pageless.settings.loader_html);
      $.pageless.loader = $('#pageless_loader');
      $('#pageless_loader .msg').html(settings.loader_msg);
    }
  };
  
  //
  $.pageless.loading = function(bool){
    if(bool === true){
      $.pageless.is_loading = true;
      if($.pageless.loader)
        $.pageless.loader.fadeIn('normal');
    } else {
      $.pageless.is_loading = false;
      if($.pageless.loader)
        $.pageless.loader.fadeOut('normal');
    }
  };
  
  $.pageless.stop_listener = function () {
    $(window).unbind('.pageless');
  };
  
  $.pageless.start_listener = function () {
    $(window).bind('scroll.pageless', $.pageless.scroll);
  };
  
  $.pageless.scroll = function () {
    // listener was stopped or we've run out of pages
    if($.pageless.settings.total_pages <= $.pageless.settings.current_page){
      $.pageless.stop_listener();
      return;
    }
    
    // distance to end of page
    var distance_to_end = $(document).height()-$(window).scrollTop()-$(window).height();
    // if slider past our scroll offset, then fire a request for more data
    if(!$.pageless.is_loading && (distance_to_end < $.pageless.settings.distance)) {
      $.pageless.loading(true);
      // move to next page
      $.pageless.settings.current_page++;
      // set up ajax query params
      $.extend($.pageless.settings.params, {page: $.pageless.settings.current_page})
      // finally ajax query
      $.get($.pageless.settings.url, $.pageless.settings.params, function(data){
        $.pageless.loader ?
          $.pageless.loader.before(data) :
          $.pageless.el.append(data)
        $.pageless.loading(false);
      });
    }
  };
})(jQuery);
