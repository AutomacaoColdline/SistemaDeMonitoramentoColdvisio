procedure ReportTitle1OnBeforePrint(Sender: TfrxComponent);
  
begin
                
      // temperatura ambiente                  
      if <Report_HistoricoGrafico_DataSetRefGroup_DataSetRef_parametros."param_temp_amb"> = True then
      begin
         TFastLineSeries(Chart1.Series[0]).LinePen.Visible := True;  
         TFastLineSeries(Chart1.Series[0]).Active := True;
         Shape1.Visible := True;  
         Memo1.Visible  := True;  
             
      end;            

      if <Report_HistoricoGrafico_DataSetRefGroup_DataSetRef_parametros."param_temp_amb"> = False then
      begin
         TFastLineSeries(Chart1.Series[0]).LinePen.Visible := False;  
         TFastLineSeries(Chart1.Series[0]).Active := False;
         Shape1.Visible := False;  
         Memo1.Visible  := False;
           
      end;
        
      // temperatura evaporador                                                                            
      if <Report_HistoricoGrafico_DataSetRefGroup_DataSetRef_parametros."param_temp_eva"> = True then
      begin
         TFastLineSeries(Chart1.Series[1]).LinePen.Visible := True;  
         TFastLineSeries(Chart1.Series[1]).Active := True;
         Shape2.Visible := True;  
         Memo2.Visible  := True;             
      end;

      if <Report_HistoricoGrafico_DataSetRefGroup_DataSetRef_parametros."param_temp_eva"> = False then
      begin
         TFastLineSeries(Chart1.Series[1]).LinePen.Visible := False;  
         TFastLineSeries(Chart1.Series[1]).Active := False;
         Shape2.Visible := False;  
         Memo2.Visible  := False;             
      end;          

      // Umidade                  
      if  <Report_HistoricoGrafico_DataSetRefGroup_DataSetRef_parametros."umid"> = True then
      begin
         TFastLineSeries(Chart1.Series[2]).LinePen.Visible := True;  
         TFastLineSeries(Chart1.Series[2]).Active := True;
         Shape3.Visible := True;  
         Memo4.Visible  := True;             
      end;

      if <Report_HistoricoGrafico_DataSetRefGroup_DataSetRef_parametros."umid"> = False then
      begin
         TFastLineSeries(Chart1.Series[2]).LinePen.Visible := False;  
         TFastLineSeries(Chart1.Series[2]).Active := False;
         Shape3.Visible := False;  
         Memo4.Visible  := False;             
      end;          
                                
end;  
  
begin

end.
