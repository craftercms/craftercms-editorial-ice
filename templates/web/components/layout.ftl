<#import "/templates/system/common/ice.ftl" as studio />

<#assign numOfColumns = (contentModel.numberOfColumns_s!1)?number>
<#assign factor = 12 / numOfColumns>

<!-- Layout Component -->
<@studio.componentRootTag class="layout-component">
  <@studio.renderRepeatCollection
    $field="items_o"
    $containerTag="div"
    $containerAttributes={ "class": "row" }
    $itemAttributes={ "class":"col-${factor} col-${factor}-xlarge col-12-small" }
    $itemTag="div";
    component, index
  >
    <#--
    TODO: The @studio.renderComponentCollection doesn't cut it here.
    The nested nature of the field creates a context variation that
    disables the macro from working. Need to explore possibilities
    around how to refactor the macro to possibly support.
     -->
    <#-- Field container element — Root of the `content_o` node-selector -->
    <@studio.div $field="items_o.content_o" $index=index>
    <#if component.content_o?? && component.content_o.item??>
      <#list component.content_o.item as item>
        <#-- Item container element — Item(s) of the `content_o` node-selector -->
        <@studio.tag $field="items_o.content_o" $index="${index}.${item?index}">
          <#-- Component element -->
          <@renderComponent component=item />
        </@studio.tag>
      </#list>
    </#if>
    </@studio.div>
  </@studio.renderRepeatCollection>
</@studio.componentRootTag>
<!-- /Layout Component -->
