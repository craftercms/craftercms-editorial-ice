<#assign numOfColumns = contentModel.numOfColumns_i!1>

<#assign n = 4>
<#assign factor = 12 / n>
<div class="row">
    <#list 0..<n as i>
      <div class="col-${factor}-xlarge col-12-small">
        Col ${i+1}
      </div>
    </#list>
</div>
