procedure ReportTitle1OnBeforePrint(Sender: TfrxComponent);
  
begin
    
      // temperatura ambiente                  
      if <Report_historico_DataSetRefGroup_DataSetRef_parametros."param_temp_amb"> = true then
      begin
         Memo4.Visible := true;                                
         Report_historico_DataSetRefGroup_DataSetRef_dadostemperatura_ambiente.Visible := true;                                 
      end;            

      if <Report_historico_DataSetRefGroup_DataSetRef_parametros."param_temp_amb"> = false then
      begin
         Memo4.Visible := false;                                
         Report_historico_DataSetRefGroup_DataSetRef_dadostemperatura_ambiente.Visible := false;                                 
      end;
        
      // temperatura evaporador                                                                            
      if <Report_historico_DataSetRefGroup_DataSetRef_parametros."param_temp_eva"> = true then
      begin
         Memo5.Visible := true;                                
         Report_historico_DataSetRefGroup_DataSetRef_dadostemperatura_evaporador.Visible := true;                                 
      end;

      if <Report_historico_DataSetRefGroup_DataSetRef_parametros."param_temp_eva"> = false then
      begin
         Memo5.Visible := false;                                
         Report_historico_DataSetRefGroup_DataSetRef_dadostemperatura_evaporador.Visible := false;                                 
      end;          

      // Umidade                                                                                             
      if <Report_historico_DataSetRefGroup_DataSetRef_parametros."umid"> = true then
      begin
         Memo6.Visible := true;                                
         Report_historico_DataSetRefGroup_DataSetRef_dadosumidade.Visible := true;                                 
      end;

      if <Report_historico_DataSetRefGroup_DataSetRef_parametros."umid"> = false then
      begin
         Memo6.Visible := false;                                
         Report_historico_DataSetRefGroup_DataSetRef_dadosumidade.Visible := false;                                 
      end;          
                                
end;  
  
begin

end.
