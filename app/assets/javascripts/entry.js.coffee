$ = jQuery

Handlebars?.register_helper "entry_classes", (items, fn) ->
	classes = ["hentry"]
	
	if 

		classes = ["hentry", keywords_as_classes(entry)]
		classes << "has_locations" if entry.has_locations?

		classes.join(" ")



Handlebars?.register_helper "formatted_title", (items, fn) ->
	

Handlebars?.register_helper "sanitized_keyword", (items, fn) ->
	

Handlebars?.register_helper "keyword_link", (items, fn) ->
	

Handlebars?.register_helper "published_at", (items, fn) ->
	

Handlebars?.register_helper "permalink", (items, fn) ->
	










<script id="entry" type="text/x-handlebars-template">
<article class="{{entry_classes entry}}">
  <header>
    <h1 class="entry-title"><{{formatted_title entry}}></h1>
  </header>
  {{#if body}}
  <section class="entry-content {{#unless body}}empty{{/unless}}">
    {{body}}
  </section>
  <section class="meta">
    {{#if entry.keywords}}
    <ul class="keywords">
      {{#each keywords}}
      <li class="tag {{sanitized_keyword keyword}}">{{keyword_link keyword}}</li>
      {{/each}}
    </ul>
    {{/if}}

    <p class="signoff">
      <span class="published updated">{{published_at entry}}</span> •
      {{#if bookmark_url}}
      <a href="{{bookmark_url}}" rel="external"><%= t("entries.bookmark_url") %></a>
      {{/if}}
      <a href="{{permalink entry}}" class="pilcrow" rel="bookmark">⁋</a>
    </p>
  </section>

  {{#if locations}}
    <%#= generate_map locations, "entry_#{entry.id}" %>
  {{/if}}
</article>
</script>