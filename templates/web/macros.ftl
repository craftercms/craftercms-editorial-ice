<#macro initPageBuilder isAuthoring=(modePreview) addReact=false>
<#if isAuthoring>
<!--
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
Crafter CMS Authoring Scripts
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
-->
<script src="/studio/static-assets/modules/editors/tinymce/v5/tinymce/tinymce.min.js"></script>
<#if addReact>
<#-- TODO: Import minified script -->
<#else>
<#-- TODO: Create Reactless build -->
<script src="/studio/static-assets/scripts/craftercms-guest.umd.js"></script>
</#if>
<script>
  window.craftercms.guest.initPageBuilder({
    path: '${model.getItem().descriptorUrl!''}',
    modelId: '${model.objectId!''}'
  });
</script>
<!--
<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
-->
</#if>
</#macro>

<#function mergeAttributes attrs $attrs>
  <#assign attributes = attrs?has_content?then(attrs, {})>
  <#assign $attributes = attributes + $attrs>
  <#return attributes + $attrs>
</#function>

<#--
TODO:
Should we put content types on the context so we can extract the content type name automatically?
-->
<#macro tag $tag="div" $model=contentModel $field="" $index="" $label="" $attrs={} attrs...>
  <#assign nested><#nested/></#assign>
  <#assign attributes = mergeAttributes(attrs, $attrs)>
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

<#macro componentRootTag $tag="div" $model=($model!contentModel) $field=($field!"") $index=($index!"") $label=($label!"") $attrs={} attrs...>
  <#assign attributes = mergeAttributes(attrs, $attrs)>
  <@tag $tag=$tag $model=$model $field=$field $index=$index $label=$label $attrs=$attributes><#nested></@tag>
</#macro>

<#macro article $model=contentModel $field="" $index="" $label="" $attrs={} attrs...>
  <#assign attributes = mergeAttributes(attrs, $attrs)>
  <@tag $tag="article" $model=$model $field=$field $index=$index $label=$label $attrs=$attributes><#nested></@tag>
</#macro>

<#macro a $model=contentModel $field="" $index="" $label="" $attrs={} attrs...>
  <#assign attributes = mergeAttributes(attrs, $attrs)>
  <@tag $tag="a" $model=$model $field=$field $index=$index $label=$label $attrs=$attributes><#nested></@tag>
</#macro>

<#macro img $model=contentModel $field="" $index="" $label="" $attrs={} attrs...>
  <#assign attributes = mergeAttributes(attrs, $attrs)>
  <@tag $tag="img" $model=$model $field=$field $index=$index $label=$label $attrs=$attributes><#nested></@tag>
</#macro>

<#macro header $model=contentModel $field="" $index="" $label="" $attrs={} attrs...>
  <#assign attributes = mergeAttributes(attrs, $attrs)>
  <@tag $tag="header" $model=$model $field=$field $index=$index $label=$label $attrs=$attributes><#nested></@tag>
</#macro>

<#macro div $model=contentModel $field="" $index="" $label="" $attrs={} attrs...>
  <#assign attributes = mergeAttributes(attrs, $attrs)>
  <@tag $tag="div" $model=$model $field=$field $index=$index $label=$label $attrs=$attributes><#nested></@tag>
</#macro>

<#macro section $model=contentModel $field="" $index="" $label="" $attrs={} attrs...>
  <#assign attributes = mergeAttributes(attrs, $attrs)>
    <@tag $tag="section" $model=$model $field=$field $index=$index $label=$label $attrs=$attributes><#nested></@tag>
</#macro>

<#macro span $model=contentModel $field="" $index="" $label="" $attrs={} attrs...>
  <#assign attributes = mergeAttributes(attrs, $attrs)>
  <@tag $tag="span" $model=$model $field=$field $index=$index $label=$label $attrs=$attributes><#nested></@tag>
</#macro>

<#macro h1 $model=contentModel $field="" $index="" $label="" $attrs={} attrs...>
  <#assign attributes = mergeAttributes(attrs, $attrs)>
  <@tag $tag="h1" $model=$model $field=$field $index=$index $label=$label $attrs=$attributes><#nested></@tag>
</#macro>

<#macro h2 $model=contentModel $field="" $index="" $label="" $attrs={} attrs...>
  <#assign attributes = mergeAttributes(attrs, $attrs)>
  <@tag $tag="h2" $model=$model $field=$field $index=$index $label=$label $attrs=$attributes><#nested></@tag>
</#macro>

<#macro h3 $model=contentModel $field="" $index="" $label="" $attrs={} attrs...>
  <#assign attributes = mergeAttributes(attrs, $attrs)>
  <@tag $tag="h3" $model=$model $field=$field $index=$index $label=$label $attrs=$attributes><#nested></@tag>
</#macro>

<#macro h4 $model=contentModel $field="" $index="" $label="" $attrs={} attrs...>
  <#assign attributes = mergeAttributes(attrs, $attrs)>
  <@tag $tag="h4" $model=$model $field=$field $index=$index $label=$label $attrs=$attributes><#nested></@tag>
</#macro>

<#macro h5 $model=contentModel $field="" $index="" $label="" $attrs={} attrs...>
  <#assign attributes = mergeAttributes(attrs, $attrs)>
  <@tag $tag="h5" $model=$model $field=$field $index=$index $label=$label $attrs=$attributes><#nested></@tag>
</#macro>

<#macro h6 $model=contentModel $field="" $index="" $label="" $attrs={} attrs...>
  <#assign attributes = mergeAttributes(attrs, $attrs)>
  <@tag $tag="h6" $model=$model $field=$field $index=$index $label=$label $attrs=$attributes><#nested></@tag>
</#macro>

<#macro ul $model=contentModel $field="" $index="" $label="" $attrs={} attrs...>
  <#assign attributes = mergeAttributes(attrs, $attrs)>
  <@tag $tag="ul" $model=$model $field=$field $index=$index $label=$label $attrs=$attributes><#nested></@tag>
</#macro>

<#macro body $model=contentModel $field="" $index="" $label="" $attrs={} attrs...>
  <#assign attributes = mergeAttributes(attrs, $attrs)>
  <@tag $tag="body" $model=$model $field=$field $index=$index $label=$label $attrs=$attributes><#nested></@tag>
</#macro>

<#macro p $model=contentModel $field="" $index="" $label="" $attrs={} attrs...>
  <#assign attributes = mergeAttributes(attrs, $attrs)>
  <@tag $tag="p" $model=$model $field=$field $index=$index $label=$label $attrs=$attributes><#nested></@tag>
</#macro>

<#macro ul $model=contentModel $field="" $index="" $label="" $attrs={} attrs...>
  <#assign attributes = mergeAttributes(attrs, $attrs)>
  <@tag $tag="ul" $model=$model $field=$field $index=$index $label=$label $attrs=$attributes><#nested></@tag>
</#macro>

<#macro ol $model=contentModel $field="" $index="" $label="" $attrs={} attrs...>
  <#assign attributes = mergeAttributes(attrs, $attrs)>
  <@tag $tag="ol" $model=$model $field=$field $index=$index $label=$label $attrs=$attributes><#nested></@tag>
</#macro>

<#macro li $model=contentModel $field="" $index="" $label="" $attrs={} attrs...>
  <#assign attributes = mergeAttributes(attrs, $attrs)>
  <@tag $tag="li" $model=$model $field=$field $index=$index $label=$label $attrs=$attributes><#nested></@tag>
</#macro>

<#macro dump_object object debug=true>
  <#compress>
    <#if object??>
      <#attempt>
        <#if object?is_node>
          <#if object?node_type == "text">${object?html}
          <#else>&lt;${object?node_name}<#if object?node_type=="element" && object.@@?has_content><#list object.@@ as attr>
            ${attr?node_name}="${attr?html}"</#list></#if>&gt;
            <#if object?children?has_content><#list object?children as item>
              <@dump_object object=item/></#list><#else>${object}</#if> &lt;/${object?node_name}&gt;</#if>
        <#elseif object?is_method>
          #method
        <#elseif object?is_sequence>
          [<#list object as item><@dump_object object=item/><#if !item?is_last>, </#if></#list>]
        <#elseif object?is_hash_ex>
          {<#list object as key, item>${key?html}=<@dump_object object=item/><#if !item?is_last>, </#if></#list>}
        <#else>
          "${object?string?html}"
        </#if>
        <#recover>
          <#if !debug><!-- </#if>LOG: Could not parse object <#if debug><pre>${.error}</pre><#else>--></#if>
      </#attempt>
    <#else>
      null
    </#if>
  </#compress>
</#macro>

<#macro renderComponentCollection $field $tag="div" $model=contentModel $attrs={} arguments={} attrs...>
  <#assign attributes = mergeAttributes(attrs, $attrs)>
  <@studio.tag $tag=$tag $field=$field $model=$model $attrs=attributes>
    <#if $model[$field]?? && $model[$field].item??>
      <#list $model[$field].item as item>
        <@renderComponent component=item additionalModel=({
        <#---->'$index': item?index,
        <#---->'$model': $model,
        <#---->'$field': $field
        } + arguments) />
      </#list>
    </#if>
  </@studio.tag>
</#macro>

<#macro renderRepeatCollection
<#---->$field
<#---->$model=contentModel
<#---->$containerTag="ul"
<#---->$containerAttributes={}
<#---->$itemTag="li"
<#---->$itemAttributes={}
>
  <@studio.tag $model=$model $field=$field $index="" $tag=$containerTag $attrs=$containerAttributes>
    <#if $model[$field]?? && $model[$field].item??>
      <#list $model[$field].item as item>
        <#assign index = item?index>
        <@studio.tag
        <#---->$model=$model
        <#---->$field=$field
        <#---->$index="${index}"
        <#---->$tag=$itemTag
        <#---->$attrs=$itemAttributes
        >
          <#nested item, index>
        </@studio.tag>
      </#list>
    </#if>
  </@studio.tag>
</#macro>
