<#--import "/templates/system/common/cstudio-support.ftl" as studio /-->
<#import "/templates/web/macros.ftl" as studio>

<!DOCTYPE HTML>
<!--
	Editorial by HTML5 UP
	html5up.net | @ajlkn
	Free for personal and commercial use under the CCA 3.0 license (html5up.net/license)
-->
<html lang="en">
<head>
  <title>${contentModel.title_t}</title>
  <meta charset="utf-8"/>
  <meta name="viewport" content="width=device-width, initial-scale=1, user-scalable=no"/>
  <link rel="stylesheet" href="/static-assets/css/main.css?v=${siteContext.siteName}"/>
  <link rel="stylesheet" href="/static-assets/css/jquery-ui.min.css"/>
</head>
<body>
<!-- Wrapper -->
<div id="wrapper">

  <!-- Main -->
  <div id="main">
    <div class="inner">

      <!-- Header -->
      <@studio.div $field="header_o">
        <@renderComponent
          component=contentModel.header_o.item
          additionalModel={
            '$index': 0,
            '$model': contentModel,
            '$field': 'header_o'
          }
        />
      </@studio.div>

      <!-- Banner -->
      <section id="banner">
        <div class="content">
          <@studio.header $field="hero_title_html" $label="Hero Title">
            ${contentModel.hero_title_html}
          </@studio.header>
          <@studio.tag $field="hero_text_html">
            ${contentModel.hero_text_html}
          </@studio.tag>
        </div>
        <span class="image object">
          <@studio.img $field="hero_image_s" src=(contentModel.hero_image_s!"") alt=""/>
        </span>
      </section>

      <!-- Section -->
      <section>
        <header class="major">
          <@studio.tag $tag="h2" $field="features_title_t">
            ${contentModel.features_title_t}
          </@studio.tag>
        </header>
        <@studio.tag $field="features_o" class="features">
          <#if contentModel.features_o?? && contentModel.features_o.item??>
            <#list contentModel.features_o.item as feature>
              <@renderComponent
                component=feature
                additionalModel={
                  '$index': feature?index,
                  '$model': contentModel,
                  '$field': 'features_o'
                }
              />
            </#list>
          </#if>
        </@studio.tag>
      </section>

      <!-- Section -->
      <#-- TODO: groovy controller needs to include model id and such so this can be ICE'cified -->
      <section>
        <header class="major">
          <h2>Featured Articles</h2>
        </header>
        <div class="posts">
          <#list articles as article>
            <@studio.article $model=article>
              <a href="${article.url}" class="image">
                <#--
                Note for docs:
                Works: src=article.image???then(article.image, "/static-assets/images/placeholder.png")
                Error: src="${article.image???then(article.image, "/static-assets/images/placeholder.png")}" 🤷
                however...
                Works: href="${article.url}"
                -->
                <@studio.img
                  $model=article
                  $field="image_s"
                  src=article.image???then(article.image, "/static-assets/images/placeholder.png")
                  alt=""
                />
              </a>
              <h3>
                <@studio.a $field="title_t" href="${article.url}">
                  ${article.title}
                </@studio.a>
              </h3>
              <@studio.p $model=article $field="summary_t">
                ${article.summary}
              </@studio.p>
              <ul class="actions">
                <li>
                  <a href="${article.url}" class="button">More</a>
                </li>
              </ul>
            </@studio.article>
          </#list>
        </div>
      </section>

    </div>
  </div>

</div>

<!-- Scripts -->
<script src="/static-assets/js/jquery.min.js"></script>
<script src="/static-assets/js/jquery-ui.min.js"></script>
<script src="/static-assets/js/skel.min.js"></script>
<script src="/static-assets/js/util.js"></script>
<script src="/static-assets/js/main.js?v=${siteContext.siteName}"></script>

<@studio.initPageBuilder/>

</body>
</html>
