{$apptype windows}
{$reference PresentationFramework.dll}
{$reference PresentationCore.dll}
{$reference WindowsBase.dll}

uses System.Windows;
uses System.Windows.Controls;

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

{$region Menu}

Procedure MainMenu(Diary: List<Entry>);
begin
  var win := new window;
  win.Name:='Diary';
  var Okn := new DockPanel;
  var SV := new ScrollViewer;
  var CC := new ContentControl;
  var Butcont := new StackPanel; 
  Dockpanel.SetDock(Okn,Dock.Left);
  SV.VerticalScrollBarVisibility := scrollbarvisibility.Auto;
  SV.HorizontalScrollBarVisibility := scrollbarvisibility.Auto;
  
  var add_button := procedure(name: string; when_clicked: ()->object)->
  begin
    var button := new Button;
    button.Content := name;
    button.Width := 200;
    button.Height := 100;
    button.Click += (o,e) -> when_clicked();
    Butcont.Children.Add(button);
  end;
  
  //add_button('Добавить событие', ()->  );
  //add_button('Показать  событие', ()->  );
  //add_button('Редактировать событие', ()->  );
  //add_button('Очистить ежедневник', ()->  );
  //add_button('Выход', () -> );
  
  SV.Content := Butcont;
  Okn.Children.Add(SV);
  Okn.Children.Add(CC);
  
  win.Content := Okn;
  Application.Create.Run(win);
end;

{$endregion Menu}

begin
  MainMenu(new List<Entry>);
end.