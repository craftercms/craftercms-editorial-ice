<#import "/templates/web/macros.ftl" as studio>

<#assign numOfColumns = (contentModel.numberOfColumns_s!1)?number>
<#assign factor = 12 / numOfColumns>

<!-- Layout Component -->
<@studio.componentRootTag>
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
    <#-- Root of the `content_o` node-selector -->
    <@studio.div $field="items_o.content_o" $index=index>
    <#if component.content_o?? && component.content_o.item??>
      <#list component.content_o.item as item>
        <#-- Item(s) of the `content_o` node-selector -->
        <@renderComponent component=item additionalModel={
          '$model': contentModel,
          '$field': 'items_o.content_o',
          '$index': '${index}.${item?index}'
        }/>
      </#list>
    </#if>
    </@studio.div>
  </@studio.renderRepeatCollection>
  <#--
  <@studio.div $field="items_o" class="row">
    <#if contentModel.items_o?? && contentModel.items_o.item??>
      <#list contentModel.items_o.item as component>
        <@studio.div $field="items_o" $index="${component?index}" class="col-${factor} col-${factor}-xlarge col-12-small">
          <@studio.div $field="items_o.content_o" $index="${component?index}">
            <#list component.content_o.item as item>
              <@renderComponent
                component=item
                additionalModel={
                  '$index': item?index,
                  '$model': contentModel,
                  '$field': 'items_o.content_o'
                }
              />
            </#list>
          </@studio.div>
        </@studio.div>
      </#list>
    </#if>
  </@studio.div>
  -->
</@studio.componentRootTag>
<!-- /Layout Component -->
