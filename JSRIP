$.fn.ripple = function(options){
	var defaults = { materialWrapper : 'material-wrapper' };
	$.extend(defaults, options);
	$(this).append('<span class="' + defaults.materialWrapper + '"></span>');
	$(this).bind('mousedown', function(e){
		$(this).find('.' + defaults.materialWrapper).removeClass('animated');
		$('.bar').css({'background' : '#eee'});
		$(this).addClass('is--rippling').css({'overflow' : 'hidden', 'position' : 'absolute'});
		var _mX = e.clientX, _mY = e.clientY;

		elementWidth = $(this).outerWidth();
		elementHeight = $(this).outerHeight();
		d = Math.max(elementWidth, elementHeight);

		$(this).find('.' + defaults.materialWrapper).css({'width' : d, 'height' : d});
		var _rpX = e.clientX - $(this).offset().left - d/2;
		var _rpY = e.clientY - $(this).offset().top - d/2;
		$(this).find('.' + defaults.materialWrapper).css('top', _rpY+'px').css('left', _rpX+'px').addClass('animated');
		if($(this).is('[colorful]')){
			$('.animated').css({'background' : 'rgba(255,255,255,0.3)'});
			$(this).find("." + defaults.materialWrapper).prev().css({'color' : '#000'});
		}else{
			$('.animated').css({'background' : 'rgba(0,0,0,0.3)'});		
			$(this).find("." + defaults.materialWrapper).prev().css({'color' : ''});
		}
	});
	$(this).bind('mouseup', function(){
		$(this).find('.' + defaults.materialWrapper).css('top', 0 + 'px').css('left', 0+'px');

		$(this).find('.' + defaults.materialWrapper).removeClass('animated');
		if($(this).is('[colorful]')){
			$('.animated').css({'background' : 'rgba(255,255,255,0.3)'});
			$(this).find("." + defaults.materialWrapper).prev().removeAttr('style');
		}else{
			$('.animated').css({'background' : 'rgba(0,0,0,0.3)'});		
			$(this).find("." + defaults.materialWrapper).prev().removeAttr('style');
		}
		$(this).removeClass('is--rippling');
	});
};
