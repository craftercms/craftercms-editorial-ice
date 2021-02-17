<#import "/templates/system/common/ice.ftl" as studio />

<!DOCTYPE HTML>
<!--
	Editorial by HTML5 UP
	html5up.net | @ajlkn
	Free for personal and commercial use under the CCA 3.0 license (html5up.net/license)
-->
<html lang="en">
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
			<@renderComponent component = contentModel.header_o.item />

			<!-- Content -->
			<section>
				<header class="main">
          <@studio.tag $tag="h1" $field="subject_t">
            ${contentModel.subject_t!""}
          </@studio.tag>
          <@studio.tag $tag="h2" $field="author_s">
            by ${contentModel.author_s!""}
          </@studio.tag>
				</header>
				<#if contentModel.image_s??>
					<#assign image = contentModel.image_s/>
				<#else>
					<#assign image = "/static-assets/images/placeholder.png"/>
				</#if>
				<span class="image main">
          <@studio.img $field='image_s' src="${image}" alt=""/>
        </span>
				<#list contentModel.sections_o.item as item>
					<div <@studio.iceAttr iceGroup="article"/>>
						${item.section_html}
					</div>
					<hr class="major" />
				</#list>
			</section>
		</div>
	</div>

	<#assign articleCategories = contentModel.queryValues("//categories_o/item/key")/>
	<#assign articlePath = contentModel.storeUrl />
	<#assign additionalModel = {"articleCategories": articleCategories, "articlePath": articlePath }/>

	<!-- Left Rail -->
	<@renderComponent component = contentModel.left_rail_o.item additionalModel = additionalModel />

</div>

<#include "/templates/web/fragments/scripts.ftl">

<@studio.initPageBuilder/>
</body>
</html>
