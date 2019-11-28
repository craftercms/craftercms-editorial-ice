<#macro renderComponents componentList parent={}>
  <#if componentList?? && componentList.item??>
    <#list componentList.item as module>
      <#if parent?has_content>
        <@renderComponent component=module parent=parent />
      <#else>
        <@renderComponent component=module />
      </#if>
    </#list>
  </#if>
</#macro>

<#macro renderRTEComponents model>

  <#assign componentCount = model['count(//rteComponents//item/id)'] />

  <#if componentCount == 1 >
    <#assign curComponentPath = ""+model['//rteComponents//item/contentId'] />
    <div style='display:none' id='o_${model['//rteComponents//item/id']}'>
      <#-- @renderComponent component=model['//rteComponents//item'] /-->
      <@renderComponent componentPath=curComponentPath />
    </div>
    <#assign item = siteItemService.getSiteItem(curComponentPath) />
    <@renderRTEComponents model=item />
  <#elseif (componentCount > 1) == true >
    <#assign components = model['//rteComponents//item'] />
    <#list components as c>
      <#if c.id??>
        <div style='display:none' id='o_${c.id}'>
          <#assign curComponentPath = "" + c.contentId />
          <@renderComponent componentPath=curComponentPath />
        </div>
        <#assign item = siteItemService.getSiteItem(curComponentPath) />
        <@renderRTEComponents model=item />
      </#if>
    </#list>
  </#if>
</#macro>

<#macro toolSupport>
  <#if modePreview>
    <script src="/studio/static-assets/libs/requirejs/require.js"
            data-main="/studio/overlayhook?site=NOTUSED&page=NOTUSED&cs.js"></script>
  </#if>
</#macro>

<#macro cstudioOverlaySupport>
  <@toolSupport />
</#macro>

<#-- Main macro for component attributes -->
<#macro componentAttr path="" ice=false iceGroup="" component={}>
  <#if !modePreview>
    <#return>
  </#if>
  <#if component?has_content>
    <@componentAttrComponent ice=ice iceGroup=iceGroup component=component />
  <#else>
    <@componentAttrLegacy ice=ice iceGroup=iceGroup path=path />
  </#if>
</#macro>

<#-- Macro to handle component attributes for a SiteItem -->
<#macro componentAttrComponent ice=false iceGroup="" component={}>
  data-studio-component="${component.storeUrl}"
  data-studio-component-path="${component.storeUrl}"
  <#if ice>
    <@iceAttrComponent component=component iceGroup=iceGroup/>
  </#if>
  <#if !component.getDom()?has_content >
    data-studio-embedded-item-id="${component.objectId}"
  </#if>
</#macro>

<#-- Macro to handle component attributes for a path -->
<#macro componentAttrLegacy path="" ice=false iceGroup="">
  data-studio-component="${path}"
  data-studio-component-path="${path}"
  <#if ice>
    <@iceAttrLegacy path=path iceGroup=iceGroup/>
  </#if>
</#macro>

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
  </#if>
</#macro>

<#-- Main macro for ICE attributes -->
<#macro iceAttr iceGroup="" path="" label="" component={} >
  <#if !modePreview>
    <#return>
  </#if>
  <#if component?has_content >
    <@iceAttrComponent iceGroup=iceGroup label=label component=component />
  <#else>
    <@iceAttrLegacy iceGroup=iceGroup label=label path=path />
  </#if>
</#macro>

<#-- Macro to handle ICE attributes for a SiteItem -->
<#macro iceAttrComponent iceGroup="" label="" component={} >
<#-- Figure out the label to use -->
  <#if label?has_content >
    <#assign actualLabel = label />
  <#elseif iceGroup?has_content >
    <#assign actualLabel = iceGroup />
  <#else>
    <#assign actualLabel = component["internal-name"] />
  </#if>
  data-studio-ice="${iceGroup}" data-studio-ice-label="${actualLabel}" data-studio-ice-path="${component.storeUrl}"
<#-- If the given component has a parent -->
  <#if !component.getDom()?has_content >
    data-studio-embedded-item-id="${component.objectId}"
  </#if>
</#macro>

<#-- Macro to handle ICE attributes for a path -->
<#macro iceAttrLegacy iceGroup="" label="" path="" >
  <#if label?has_content >
    <#assign actualLabel = label />
  <#elseif iceGroup?has_content >
    <#assign actualLabel = iceGroup />
  <#else>
    <#assign actualLabel = path />
  </#if>
  data-studio-ice="${iceGroup}" data-studio-ice-label="${actualLabel}"
  <#if path?has_content >
    data-studio-ice-path="${path}"
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

<h1>Hey, Macro!</h1>