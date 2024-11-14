procedure ReportTitle1OnBeforePrint(Sender: TfrxComponent);

begin  




    if <Report_HistoricoGrafico_DataSetRefGroup_DataSetRef_dados."dado_1"> = 22 then
    begin
        TFastLineSeries(Chart1.Series[0]).LinePen.Visible := false;
        TFastLineSeries(Chart1.Series[0]).Active := false;        
    end;

    TFastLineSeries(Chart1.Series[0]).LinePen.Visible := True;
    TFastLineSeries(Chart1.Series[0]).Active := True;        
    TFastLineSeries(Chart1.Series[1]).LinePen.Visible := True;
    TFastLineSeries(Chart1.Series[1]).Active := True;
    TFastLineSeries(Chart1.Series[2]).LinePen.Visible := True;
    TFastLineSeries(Chart1.Series[2]).Active := True;
      
    TFastLineSeries(Chart1.Series[3]).LinePen.Visible := True;
    TFastLineSeries(Chart1.Series[3]).Active := True;              
    TFastLineSeries(Chart1.Series[4]).LinePen.Visible := True;
    TFastLineSeries(Chart1.Series[4]).Active := True;
    TFastLineSeries(Chart1.Series[5]).LinePen.Visible := True;
    TFastLineSeries(Chart1.Series[5]).Active := True;
      
    TFastLineSeries(Chart1.Series[6]).LinePen.Visible := True;
    TFastLineSeries(Chart1.Series[6]).Active := True;              
    TFastLineSeries(Chart1.Series[7]).LinePen.Visible := True;
    TFastLineSeries(Chart1.Series[7]).Active := True;
    TFastLineSeries(Chart1.Series[8]).LinePen.Visible := True;
    TFastLineSeries(Chart1.Series[8]).Active := True;

    TFastLineSeries(Chart1.Series[9]).LinePen.Visible := True;
    TFastLineSeries(Chart1.Series[9]).Active := True;
    TFastLineSeries(Chart1.Series[10]).LinePen.Visible := True;
    TFastLineSeries(Chart1.Series[10]).Active := True;
    TFastLineSeries(Chart1.Series[11]).LinePen.Visible := True;
    TFastLineSeries(Chart1.Series[11]).Active := True;

    TFastLineSeries(Chart1.Series[12]).LinePen.Visible := True;
    TFastLineSeries(Chart1.Series[12]).Active := True;
    TFastLineSeries(Chart1.Series[13]).LinePen.Visible := True;
    TFastLineSeries(Chart1.Series[13]).Active := True;
    TFastLineSeries(Chart1.Series[14]).LinePen.Visible := True;
    TFastLineSeries(Chart1.Series[14]).Active := True;      

end;

begin
end.

