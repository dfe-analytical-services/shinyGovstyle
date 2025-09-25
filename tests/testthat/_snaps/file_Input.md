# file input HTML is as expected

    Code
      file_Input("inputId", "Test", multiple = T, accept = c(".xls"))
    Output
      <div id="inputIddiv" class="govuk-form-group">
        <label class="govuk-label" tabindex="-1">Test</label>
        <div id="inputIdfile_div" class="input-group govuk-file-upload" style="display: flex; align-items: center;">
          <label class="govuk-button govuk-button--secondary govuk-file-upload-button__pseudo-button" style="margin-bottom: 0; position: relative; overflow: hidden;">
            Choose file
            <input id="inputId" name="inputId" type="file" style="position: absolute; width: 1px; height: 1px; padding: 0; margin: -1px; overflow: hidden; clip: rect(0,0,0,0); border: 0;" multiple="multiple" accept=".xls"/>
          </label>
          <input type="text" class="govuk-body" style="margin: 0; border: 0; outline: none; width: 98%; flex: 1 1 auto;" placeholder="No file chosen" readonly="readonly" tabindex="-1"/>
        </div>
      </div>

