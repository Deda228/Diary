{$apptype windows}
{$reference PresentationFramework.dll}
{$reference PresentationCore.dll}
{$reference WindowsBase.dll}

uses System.Windows,
     System.Windows.Controls,
     System.Windows.Media;

{$region Type}

type
  Entry = record
    DateAndTime: DateTime;
    Task: string;
    Done: boolean;
    
    Constructor (NewDateAndTime: DateTime; NewTask: string; NewDone: boolean);
    begin
      DateAndTime := NewDateAndTime;
      Task := NewTask; 
      Done := NewDone; 
    end;
    
    function WithDone(New_status:boolean):Entry;
    begin
      Result := self;
      Result.Done := New_status;
    end;
    
    function WithTask(New_Task: string): Entry;
    begin
      Result := self;
      Result.Task := New_Task;
    end;
    
    function WithDateAndTime(New_Date: datetime): Entry;
    begin
      Result := self;
      Result.DateAndTime := New_Date;
    end;
    
  end;
  
{$endregion Type}

{$region Compare} 
 
function CompareEntriesByTime(Entry1, Entry2: Entry): integer; 
begin 
  Result :=DateTime.Compare(Entry1.DateAndTime,Entry2.DateAndTime); 
end; 
 
{$endregion Compare} 

{$region Add} 
 
function AddEntry(Diary: List<Entry>): border; 
begin
  
  var SPFon := new border;
  SPFon.Background := Brushes.AliceBlue;
  
  var SV := new ScrollViewer;
  SPFon.Child := SV;
  
  var SP := new StackPanel;
  SV.Content := SP;
  
  var DockP0 := new DockPanel;
  DockP0.HorizontalAlignment := HorizontalAlignment.left;
  DockP0.Margin := new Thickness(20);
  
  var T1 := new System.Windows.Controls.Label;
  DockP0.Children.Add(T1);
  T1.Content := 'Введите описание события: ';
  T1.FontSize := 20;
  T1.VerticalAlignment := VerticalAlignment.Center;
  
  var TB := new TextBox;
  DockP0.Children.Add(TB);
  TB.MinWidth := 200;
  TB.TextWrapping := Textwrapping.Wrap;
  TB.FontSize := 25;
  TB.HorizontalContentAlignment := HorizontalAlignment.Center;
  
  SP.Children.Add(DockP0);
 
  var DockP1 := new DockPanel;
  DockP1.HorizontalAlignment := HorizontalAlignment.left;
  DockP1.Margin := new Thickness(20);
  
  var T2 := new System.Windows.Controls.Label;
  DockP1.Children.Add(T2);
  T2.Content := 'Введите дату события: ';
  T2.FontSize := 20;
  T2.HorizontalContentAlignment := HorizontalAlignment.Center; 
  
  var DP := new DatePicker;
  DockP1.Children.Add(DP);
  DP.FontSize := 20;
  //DP.Width := 230;
  DP.Language := System.Windows.Markup.XmlLanguage.GetLanguage('ru-RU');
  DP.SelectedDateFormat := DatePickerformat.Long;
  DP.HorizontalContentAlignment := HorizontalAlignment.Center;
  DP.DisplayDateStart := datetime.Today;
  
  SP.Children.Add(DockP1);

  var DockP2 := new DockPanel;
  DockP2.HorizontalAlignment := HorizontalAlignment.Left;
  DockP2.Margin := new Thickness(20); 
   
  var T3 := new System.Windows.Controls.Label;
  DockP2.Children.Add(T3);
  T3.Content := 'Введите время события: ';
  T3.FontSize := 20;
  T3.HorizontalContentAlignment := HorizontalAlignment.Center;
  
  var hourTextBox := new TextBox;
  DockP2.Children.Add(hourTextBox);
  hourTextBox.FontSize := 20;
  hourTextBox.Width := 50;
  hourTextBox.HorizontalContentAlignment := HorizontalAlignment.Center;
  hourTextBox.MaxLength := 2;
  
  var T4 := new System.Windows.Controls.Label;
  DockP2.Children.Add(T4);
  T4.Content := ':';
  T4.FontSize := 20;
  T4.HorizontalContentAlignment := HorizontalAlignment.Center;
  
  var minuteTextBox := new TextBox;
  DockP2.Children.Add(minuteTextBox);
  minuteTextBox.FontSize := 20;
  minuteTextBox.Width := 50;
  minuteTextBox.HorizontalContentAlignment := HorizontalAlignment.Center;
  minuteTextBox.MaxLength := 2;
  
  SP.Children.Add(DockP2);
    
  var addButton := new Button;
  SP.Children.Add(addButton);
  addbutton.HorizontalAlignment := HorizontalAlignment.Left;
  addbutton.Margin := new Thickness(20);
  addbutton.Width := 200;
  addbutton.Height := 70;
  addButton.Content := 'Подтвердить';
  addButton.Click += (o, e) -> 
    begin
      if (DP.SelectedDate <> nil) and (TB.Text <> '') and (hourTextBox.Text <> '') and (minuteTextBox.Text <> '') then
        begin
          var hour := Convert.ToInt32(hourTextBox.Text);
          var minute := Convert.ToInt32(minuteTextBox.Text);
          if (hour >= 0) and (hour <= 23) and (minute >= 0) and (minute <= 59) then
            begin
              var selectedDateTime := new DateTime(DP.SelectedDate.Value.Year, DP.SelectedDate.Value.Month, DP.SelectedDate.Value.Day, hour, minute, 0);
              Diary.Add(Entry.Create(selectedDateTime, TB.Text, False));
              Diary.Sort(CompareEntriesByTime);
              SP.Children.Clear();
            end
          else
            MessageBox.Show('Время введено неверно', 'Ошибка!');
        end
      else 
        MessageBox.Show('Дата введена неверно', 'Ошибка!');
    end;
  result := SPFon;
end;

{$endregion Add} 

{$region Print}

function PrintEntries(Diary: List<Entry>): Border;
begin
  var Fon := new Border;
  Fon.Background := Brushes.AliceBlue;
  
  var SV := new ScrollViewer;
  Fon.Child := SV;
  SV.VerticalScrollBarVisibility := scrollbarvisibility.Auto;
  SV.HorizontalScrollBarVisibility := scrollbarvisibility.Auto;
  
  var tablet := new Grid;
  SV.Content := tablet;
  tablet.Language := System.Windows.Markup.XmlLanguage.GetLanguage('ru-RU');
  tablet.HorizontalAlignment := HorizontalAlignment.Stretch;
  tablet.ShowGridLines := True;
  
  var colDef1 := new ColumnDefinition;
  tablet.ColumnDefinitions.Add(colDef1);
  
  var colDef2 := new ColumnDefinition;
  tablet.ColumnDefinitions.Add(colDef2);
  
  var colDef3 := new ColumnDefinition;
  tablet.ColumnDefinitions.Add(colDef3);
  
  for var i := 0 to Diary.Count - 1 do
  begin
    var row := new RowDefinition;
    tablet.RowDefinitions.Add(row);
    
    var txt1 := new TextBlock;
    tablet.Children.Add(txt1);
    txt1.Text := Diary[i].DateAndTime.ToString;
    txt1.HorizontalAlignment := HorizontalAlignment.Center;
    txt1.VerticalAlignment := VerticalAlignment.Center;
    txt1.Margin := new Thickness(20);
    txt1.FontSize := 25;
    Grid.SetColumn(txt1, 0); 
    Grid.SetRow(txt1, i); 
    
    var SVTXT := new ScrollViewer;
    tablet.Children.Add(SVTXT);
    SVTXT.MaxHeight := 300;
    Grid.SetColumn(SVTXT, 1); 
    Grid.SetRow(SVTXT, i); 
    
    var txt2 := new TextBlock;
    SVTXT.Content := txt2;
    txt2.Text := Diary[i].Task;
    txt2.HorizontalAlignment := HorizontalAlignment.Center;
    txt2.VerticalAlignment := VerticalAlignment.Center;
    txt2.TextWrapping := TextWrapping.Wrap;
    txt2.MaxWidth := 400;
    txt2.Margin := new Thickness(20);
    txt2.FontSize := 25;
    
    var txt3 := new TextBlock;
    tablet.Children.Add(txt3);
    txt3.Text := Diary[i].Done.ToString;
    txt3.HorizontalAlignment := HorizontalAlignment.Center;
    txt3.VerticalAlignment := VerticalAlignment.Center;
    txt3.Margin := new Thickness(20);
    txt3.FontSize := 25;
    Grid.SetColumn(txt3, 2); 
    Grid.SetRow(txt3, i); 
  end;
  
  if diary.Count = 0 then
    begin
      var EmptyText := new TextBlock;
      Fon.Child := EmptyText;
      EmptyText.Text := 'Ежедневник пуст!';
      EmptyText.FontSize := 50;
      EmptyText.VerticalAlignment := VerticalAlignment.Center;
      EmptyText.HorizontalAlignment := HorizontalAlignment.Center;
    end;
  result := Fon;
end;
{$endregion Print}

{$region Menu}

Procedure MainMenu(Diary: List<Entry>);
begin
  var win := new window;
  win.MinHeight := 400;
  win.MinWidth := 800;
  win.Name:='Diary';
  
  var Okn := new DockPanel;
  win.Content := Okn;
  Dockpanel.SetDock(Okn,Dock.Left);
  
  var SVFon := new Border;
  Okn.Children.Add(SVFon);
  SVFon.Background := Brushes.Gray;
  
  var SV := new ScrollViewer;
  SVFon.Child := SV;
  SV.Margin := new Thickness(10);
  SV.VerticalScrollBarVisibility := scrollbarvisibility.Auto;
  SV.HorizontalScrollBarVisibility := scrollbarvisibility.Auto;
  
  var Butcont := new StackPanel;
  SV.Content := Butcont;
  
  var EmptySpace := new System.Windows.Controls.Label;
  EmptySpace.Content := '  ';
  EmptySpace.FontSize := 20;
 
  var CC := new ContentControl;
  Okn.Children.Add(CC);
  
  var add_button := procedure(name: string; when_clicked: ()->object)->
  begin
    var button := new Button;
    button.Content := name;
    button.Width := 200;
    button.Height := 100;
    button.Click += (o,e) -> 
      begin 
        CC.Content :=  when_clicked(); 
      end;
    Butcont.Children.Add(button);
  end;
  
  add_button('Добавить событие', ()-> AddEntry(Diary));
  add_button('Показать  события', ()-> PrintEntries(Diary));
  //add_button('Редактировать событие', ()->  );
  //add_button('Очистить ежедневник', ()->  );
  //add_button('Выход', () -> );
  
  Application.Create.Run(win);
end;

{$endregion Menu}

{$region Main}
begin
  MainMenu(new List<Entry>);
end.
{$endregion Main}