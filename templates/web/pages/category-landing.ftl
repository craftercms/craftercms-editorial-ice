<#--<#import "/templates/system/common/cstudio-support.ftl" as studio />-->
<#import "/templates/web/macros.ftl" as studio>

<!DOCTYPE HTML>
<!--
	Editorial by HTML5 UP
	html5up.net | @ajlkn
	Free for personal and commercial use under the CCA 3.0 license (html5up.net/license)
-->
<html>
<head>
    <#include "/templates/web/fragments/head.ftl">
</head>
<body>
<!-- Wrapper -->
<div id="wrapper">

  <!-- Main -->
  <div id="main">
    <div class="inner">

      <!-- Header -->
      <@renderComponent component=contentModel.header_o.item />

      <!-- Section -->
      <section <@studio.iceAttr iceGroup="articles"/>>
        <header class="main">
          <h1>${contentModel.articles_title_t}</h1>
        </header>
        <div class="posts">
          <#list articles as article>
            <article>
              <a href="${article.url}" class="image">
                <#if article.image??>
                  <#assign articleImage = article.image/>
                <#else>
                  <#assign articleImage = "/static-assets/images/placeholder.png"/>
                </#if>
                <img src="${articleImage}" alt=""/>
              </a>
              <h3><a href="${article.url}">${article.title}</a></h3>
              <p>${article.summary}</p>
              <ul class="actions">
                <li><a href="${article.url}" class="button">More</a></li>
              </ul>
            </article>
          </#list>
        </div>
      </section>

    </div>
  </div>

  <!-- Left Rail -->
  <@renderComponent component=contentModel.left_rail_o.item />

</div>

<#include "/templates/web/fragments/scripts.ftl">

<@studio.toolSupport/>
</body>
