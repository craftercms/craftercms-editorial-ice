<#macro toolSupport>
  <#if modePreview>
    <script src="http://authoring.sample.com:3000/craftercms-guest.umd.js"></script>
  <#--
  <script
    src="/studio/static-assets/libs/requirejs/require.js"
    data-main="/studio/overlayhook?site=NOTUSED&page=NOTUSED&cs.js"
  ></script>
  -->
  </#if>
</#macro>

<#macro cstudioOverlaySupport>
  <@toolSupport />
</#macro>

<#-- Macro for component attributes -->
<#macro componentAttr path="" ice=false iceGroup="" component={}>
  <#if !modePreview>
    <#return>
  </#if>
  <#if !component?has_content>
    <#assign item = siteItemService.getSiteItem(path)/>
  <#else>
    <#assign item = component/>
  </#if>
  data-studio-component="${item.storeUrl}"
  data-studio-component-path="${item.storeUrl}"
  <#if ice>
    <@iceAttr component=item iceGroup=iceGroup/>
  </#if>
  <#if !ice && !item.dom?has_content >
    data-studio-embedded-item-id="${item.objectId}"
  </#if>
</#macro>

<#-- Macro for drop zone attributes -->
<#macro componentContainerAttr target objectId="" component={}>
  <#if !modePreview>
    <#return>
  </#if>
  data-studio-components-target="${target}"
  <#if component?has_content>
  <#-- Use the component object -->
    data-studio-components-objectId="${component.objectId}"
    data-studio-zone-content-type="${component['content-type']}"
  <#else>
  <#-- Use objectId for backwards compatibility -->
    data-studio-components-objectId="${objectId}"
    data-studio-zone-content-type="${contentModel['content-type']}"
  </#if>
</#macro>

<#-- Macro for ICE attributes -->
<#macro iceAttr iceGroup="" path="" label="" component={} >
  <#if !modePreview>
    <#return>
  </#if>
  <#if !(component?has_content)>
    <#if path?has_content>
      <#assign item = siteItemService.getSiteItem(path)/>
    <#else>
      <#assign item = contentModel/>
    </#if>
  <#else>
    <#assign item = component/>
  </#if>
<#-- Figure out the label to use -->
  <#if label?has_content >
    <#assign actualLabel = label />
  <#elseif iceGroup?has_content >
    <#assign actualLabel = iceGroup />
  <#else>
    <#assign actualLabel = item["internal-name"]!"" />
  </#if>
  data-studio-ice="${iceGroup}" data-studio-ice-label="${actualLabel}" data-studio-ice-path="${item.storeUrl}"
<#-- If the given component has a parent -->
  <#if !item.dom?has_content >
    data-studio-embedded-item-id="${item.objectId}"
  </#if>
</#macro>

<#macro ice id="" component="" componentPath="">
  <#if modePreview>
    <div data-studio-ice="${id}"></div>
  </#if>
</#macro>

<#macro draggableComponent id="" component="" componentPath="">
  <#if modePreview>
    <#if id != "" && component == "" && componentPath == "">
      <@ice id=id>
        <div id='${id}' class='cstudio-draggable-component'><#nested></div>
      </@ice>
    <#elseif id == "" && componentPath == "">
      <@ice component=component>
        <div id="cstudio-component-${component.key}" class='cstudio-draggable-component'><#nested></div>
      </@ice>
    <#elseif id == "" && component == "">
      <@ice componentPath=componentPath>
        <div id="cstudio-component-${componentPath}" class='cstudio-draggable-component'><#nested></div>
      </@ice>
    </#if>
  <#else>
    <#nested>
  </#if>
</#macro>

<#macro componentZone id="">
  <div class="cstudio-component-zone" id="zone-${id}">
    <@ice id=id>
      <#nested>
    </@ice>
  </div>
</#macro>

<#--
TODO:
Can we put content types on the context so we can extract the content type name automatically?
-->
<#macro tag $tag="div" $model=contentModel $field="" $index="" $label="" $attrs={} attrs...>
  <#assign nested><#nested/></#assign>
  <#assign attributes = attrs?has_content?then(attrs, {})>
  <#assign $attributes = attributes + $attrs/>
  <#if nested?has_content>
    <#assign nested = "\n${nested}  ">
  </#if>
  <${$tag}
  <#list $attributes as attr, value>
    ${attr}="${value}"
  </#list>
  <#if modePreview && $model?has_content>
    data-craftercms-model-id="${$model.objectId}"
    <#if $field?has_content>
    <#---->data-craftercms-field-id="${$field}"
    </#if>
    <#if $index?has_content>
    <#---->data-craftercms-index="${$index}"
    </#if>
    <#if $label?has_content>
    <#---->data-craftercms-label="${$label}"
    </#if>
  </#if>
  >${nested}</${$tag}>
</#macro>

<#macro article $model=contentModel $field="" $index="" $label="" $attrs={} attrs...>
  <#assign attributes = attrs?has_content?then(attrs, {})>
  <#assign $attributes = attributes + $attrs/>
  <@tag $tag="article" $model=$model $field=$field $index=$index $label=$label $attrs=$attributes><#nested></@tag>
</#macro>

<#macro a $model=contentModel $field="" $index="" $label="" $attrs={} attrs...>
  <#assign attributes = attrs?has_content?then(attrs, {})>
  <#assign $attributes = attributes + $attrs/>
  <@tag $tag="a" $model=$model $field=$field $index=$index $label=$label $attrs=$attributes><#nested></@tag>
</#macro>

<#macro img $model=contentModel $field="" $index="" $label="" $attrs={} attrs...>
  <#assign attributes = attrs?has_content?then(attrs, {})>
  <#assign $attributes = attributes + $attrs/>
  <@tag $tag="img" $model=$model $field=$field $index=$index $label=$label $attrs=$attributes><#nested></@tag>
</#macro>

<#macro header $model=contentModel $field="" $index="" $label="" $attrs={} attrs...>
  <#assign attributes = attrs?has_content?then(attrs, {})>
  <#assign $attributes = attributes + $attrs/>
  <@tag $tag="header" $model=$model $field=$field $index=$index $label=$label $attrs=$attributes><#nested></@tag>
</#macro>

<#macro div $model=contentModel $field="" $index="" $label="" $attrs={} attrs...>
  <#assign attributes = attrs?has_content?then(attrs, {})>
  <#assign $attributes = attributes + $attrs/>
  <@tag $tag="div" $model=$model $field=$field $index=$index $label=$label $attrs=$attributes><#nested></@tag>
</#macro>

<#macro section $model=contentModel $field="" $index="" $label="" $attrs={} attrs...>
    <#assign attributes = attrs?has_content?then(attrs, {})>
    <#assign $attributes = attributes + $attrs/>
    <@tag $tag="section" $model=$model $field=$field $index=$index $label=$label $attrs=$attributes><#nested></@tag>
</#macro>

<#macro span $model=contentModel $field="" $index="" $label="" $attrs={} attrs...>
  <#assign attributes = attrs?has_content?then(attrs, {})>
  <#assign $attributes = attributes + $attrs/>
  <@tag $tag="span" $model=$model $field=$field $index=$index $label=$label $attrs=$attributes><#nested></@tag>
</#macro>

<#macro h1 $model=contentModel $field="" $index="" $label="" $attrs={} attrs...>
  <#assign attributes = attrs?has_content?then(attrs, {})>
  <#assign $attributes = attributes + $attrs/>
  <@tag $tag="h1" $model=$model $field=$field $index=$index $label=$label $attrs=$attributes><#nested></@tag>
</#macro>
<#macro h2 $model=contentModel $field="" $index="" $label="" $attrs={} attrs...>
  <#assign attributes = attrs?has_content?then(attrs, {})>
  <#assign $attributes = attributes + $attrs/>
  <@tag $tag="h2" $model=$model $field=$field $index=$index $label=$label $attrs=$attributes><#nested></@tag>
</#macro>
<#macro h3 $model=contentModel $field="" $index="" $label="" $attrs={} attrs...>
  <#assign attributes = attrs?has_content?then(attrs, {})>
  <#assign $attributes = attributes + $attrs/>
  <@tag $tag="h3" $model=$model $field=$field $index=$index $label=$label $attrs=$attributes><#nested></@tag>
</#macro>
<#macro h4 $model=contentModel $field="" $index="" $label="" $attrs={} attrs...>
  <#assign attributes = attrs?has_content?then(attrs, {})>
  <#assign $attributes = attributes + $attrs/>
  <@tag $tag="h4" $model=$model $field=$field $index=$index $label=$label $attrs=$attributes><#nested></@tag>
</#macro>
<#macro h5 $model=contentModel $field="" $index="" $label="" $attrs={} attrs...>
  <#assign attributes = attrs?has_content?then(attrs, {})>
  <#assign $attributes = attributes + $attrs/>
  <@tag $tag="h5" $model=$model $field=$field $index=$index $label=$label $attrs=$attributes><#nested></@tag>
</#macro>
<#macro h6 $model=contentModel $field="" $index="" $label="" $attrs={} attrs...>
  <#assign attributes = attrs?has_content?then(attrs, {})>
  <#assign $attributes = attributes + $attrs/>
  <@tag $tag="h6" $model=$model $field=$field $index=$index $label=$label $attrs=$attributes><#nested></@tag>
</#macro>

<#macro ul $model=contentModel $field="" $index="" $label="" $attrs={} attrs...>
  <#assign attributes = attrs?has_content?then(attrs, {})>
  <#assign $attributes = attributes + $attrs/>
  <@tag $tag="ul" $model=$model $field=$field $index=$index $label=$label $attrs=$attributes><#nested></@tag>
</#macro>

<#macro body $model=contentModel $field="" $index="" $label="" $attrs={} attrs...>
  <#assign attributes = attrs?has_content?then(attrs, {})>
  <#assign $attributes = attributes + $attrs/>
  <@tag $tag="body" $model=$model $field=$field $index=$index $label=$label $attrs=$attributes><#nested></@tag>
</#macro>

<#macro p $model=contentModel $field="" $index="" $label="" $attrs={} attrs...>
  <#assign attributes = attrs?has_content?then(attrs, {})>
  <#assign $attributes = attributes + $attrs/>
  <@tag $tag="p" $model=$model $field=$field $index=$index $label=$label $attrs=$attributes><#nested></@tag>
</#macro>

<#--
<#macro div></#macro>
<#macro article></#macro>
<#macro section></#macro>
<#macro h1></#macro>
<#macro h2></#macro>
<#macro h3></#macro>
-->
