<#--<#import "/templates/system/common/cstudio-support.ftl" as studio />-->
<#import "/templates/web/macros.ftl" as studio>

<@studio.article $model=($model!contentModel) $field=($field!"") $index=($index!"") $label=($label!"")>
  <@studio.span class="icon ${contentModel.icon_s}" $field="icon_s"/>
  <div class="content">
    <@studio.h3 $field="title_t">
      ${contentModel.title_t}
    </@studio.h3>
    <@studio.span $field="body_html">
      ${contentModel.body_html}
    </@studio.span>
  </div>
</@studio.article>
