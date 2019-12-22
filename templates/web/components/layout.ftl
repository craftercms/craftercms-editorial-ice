<#import "/templates/web/macros.ftl" as studio>

<#assign numOfColumns = (contentModel.numberOfColumns_s!1)?number>
<#assign factor = 12 / numOfColumns>

<!-- Layout Component -->
<@studio.div $model=($model!contentModel) $field=($field!"") $index=($index!"") $label=($label!"")>
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
</@studio.div>
<!-- /Layout Component -->

<#--
<@studio.div $field="items_o" class="row">
<#if contentModel.items_o?? && contentModel.items_o.item??>
<#list contentModel.items_o.item as component>
<div class="col-${factor} col-${factor}-xlarge col-12-small">
  <@renderComponent
    component=component.content_o.item
    additionalModel={
      '$index': component?index,
      '$model': contentModel,
      '$field': 'items_o'
    }
  />
</div>
</#list>
</#if>
</@studio.div>
-->

<#--
  <@renderComponent
    component=component.content_o.item
    additionalModel={
      '$index': component?index,
      '$model': contentModel,
      '$field': 'items_o'
    }
  />
-->
