/*
 * FullCalendar v1.4.7 Google Calendar Extension
 *
 * Copyright (c) 2009 Adam Shaw
 * Dual licensed under the MIT and GPL licenses:
 *   http://www.opensource.org/licenses/mit-license.php
 *   http://www.gnu.org/licenses/gpl.html
 *
 * Date: Mon Jul 5 16:07:40 2010 -0700
 *
 */

(function($) {

	$.fullCalendar.gcalFeed = function(feedUrl, options) {
		
		feedUrl = feedUrl.replace(/\/basic$/, '/full');
		options = options || {};
		
		return function(start, end, callback) {
			var params = {
				'start-min': "2010-09-25T00:00:00.000-07:00", // $.fullCalendar.formatDate(start, 'u'),
				'start-max': "2010-09-26T00:00:00.000-07:00",// $.fullCalendar.formatDate(end, 'u'),
				'singleevents': true,
				'max-results': 9999
			};
			var ctz = options.currentTimezone;
			if (ctz) {
				params.ctz = ctz = ctz.replace(' ', '_');
			}
			var finalUrl = feedUrl + "?alt=json-in-script&callback=?";
			console.log(finalUrl);
			console.log(params);
			$.getJSON(finalUrl, params, function(data) {
				var events = [];
				if (data.feed.entry) {
					$.each(data.feed.entry, function(i, entry) {
						var startStr = entry['gd$when'][0]['startTime'],
							start = $.fullCalendar.parseISO8601(startStr, true),
							end = $.fullCalendar.parseISO8601(entry['gd$when'][0]['endTime'], true),
							allDay = startStr.indexOf('T') == -1,
							url;
						$.each(entry.link, function() {
							if (this.type == 'text/html') {
								url = this.href;
								if (ctz) {
									url += (url.indexOf('?') == -1 ? '?' : '&') + 'ctz=' + ctz;
								}
							}
						});
						if (allDay) {
							$.fullCalendar.addDays(end, -1); // make inclusive
						}
						events.push({
							id: entry['gCal$uid']['value'],
							title: entry['title']['$t'],
							url: url,
							start: start,
							end: end,
							allDay: allDay,
							location: entry['gd$where'][0]['valueString'],
							description: entry['content']['$t'],
							className: options.className,
							editable: options.editable || false
						});
					});
				}
				callback(events);
			});
		}
		
	}

})(jQuery);
