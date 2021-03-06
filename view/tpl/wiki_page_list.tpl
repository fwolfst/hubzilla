{{if ! $refresh}}
<div id="wiki_page_list" class="widget" >
{{/if}}
	<h3>{{$header}}</h3>
	<ul class="nav nav-pills flex-column">
		{{if $pages}}
		{{foreach $pages as $page}}
		<li class="nav-item nav-item-hack" id="{{$page.link_id}}">
			{{if $page.resource_id && $candel}}
			<i class="nav-link widget-nav-pills-icons fa fa-trash-o drop-icons" onclick="wiki_delete_page('{{$page.title}}', '{{$page.url}}', '{{$page.resource_id}}', '{{$page.link_id}}')"></i>
			{{/if}}
			<a class="nav-link" href="/wiki/{{$channel_address}}/{{$wikiname}}/{{$page.url}}">{{$page.title}}</a>
		</li>
		{{/foreach}}
		{{/if}}
		{{if $canadd}}
		<li class="nav-item"><a class="nav-link" href="#" onclick="wiki_show_new_page_form(); return false;"><i class="fa fa-plus-circle"></i>&nbsp;{{$addnew}}</a></li>
		{{/if}}
	</ul>
	{{if $canadd}}
	<div id="new-page-form-wrapper" class="sub-menu" style="display:none;">
		<form id="new-page-form" action="wiki/{{$channel_address}}/create/page" method="post" >
			<input type="hidden" name="resource_id" value="{{$resource_id}}">
			{{include file="field_input.tpl" field=$pageName}}
			<button id="new-page-submit" class="btn btn-primary" type="submit" name="submit" >Submit</button>
		</form>
	</div>
	{{/if}}
{{if ! $refresh}}
</div>
{{/if}}

{{if $canadd}}
<script>
	$('#new-page-submit').click(function (ev) {
		$.post("wiki/{{$channel_address}}/create/page", {pageName: $('#id_pageName').val(), resource_id: window.wiki_resource_id},
		function(data) {
			if(data.success) {
				window.location = data.url;
			} else {
				window.console.log('Error creating page.');
			}
		}, 'json');
		ev.preventDefault();
	});

	function wiki_delete_page(wiki_page_name, wiki_page_url, wiki_resource_id, wiki_link_id) {
		if(!confirm('Are you sure you want to delete the page: ' + wiki_page_name)) {
			return;
		}
		$.post("wiki/{{$channel_address}}/delete/page", {name: wiki_page_url, resource_id: wiki_resource_id},
		function (data) {
			if (data.success) {
				window.console.log('Page deleted successfully.');
				if(wiki_page_url == window.wiki_page_name) {
					var url = window.location.href;
					if(url.substr(-1) == '/')
						url = url.substr(0, url.length - 2);
					url = url.split('/');
					url.pop();
					window.location = url.join('/');
				}
				else {
					$('#' + wiki_link_id).remove();
				}
			} else {
				alert('Error deleting page.'); // TODO: Replace alerts with auto-timeout popups
				window.console.log('Error deleting page.');
			}
		}, 'json');
		return false;
	}

	function wiki_show_new_page_form() {
		$('#new-page-form-wrapper').toggle();
		$('#id_pageName').focus();
		return false;
	}
</script>
{{/if}}
