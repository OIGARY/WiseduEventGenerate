
disp('Wisedu Class Generate');

% 读取课表
Table = readtable('课表.xls');
Post = table();

TableSize = size(Table);

for i = 1:TableSize(1)
    % 读取一行作为 Cell
    Line = Table(i,:);
    C_Name = Line{1,2};
    C_Routine = Line{1,5};
    C_Wkd = Line{1,6};
    C_Wkd = str2num(C_Wkd{1});
    C_BgS = Line{1,7};
    C_BgS = str2num(C_BgS{1});
    C_EdS = Line{1,8};
    C_EdS = str2num(C_EdS{1});
    C_Pos = Line{1,10};
    % 处理 Routine
    C_Routine = strsplit(C_Routine{1}, ',');
    CellSize = size(C_Routine);
    C_Week = [];
    for j = 1:CellSize(2)
        TempPair = [0,0,4];
        TempPos = strfind(C_Routine{j},'(单)');
        if TempPos
            TempPair(3) = 1;
            C_Routine(j) = strrep(C_Routine(j), '(单)', '');
        end
        TempPos = strfind(C_Routine{j},'(双)');
        if TempPos
            TempPair(3) = 2;
            C_Routine(j) = strrep(C_Routine(j), '(单)', '');
        end
        if TempPair(3) == 4
            TempPair(3) = 0;
        end
        C_Routine(j) = strrep(C_Routine(j), '周', '');
        TempPos = strfind(C_Routine{j},'-');
        if TempPos
            TempPair(1) = str2num(C_Routine{j}(1:TempPos-1));
            TempPair(2) = str2num(C_Routine{j}(TempPos+1:end));
        else
            TempPair(1) = str2num(C_Routine{j});
            TempPair(2) = str2num(C_Routine{j});
        end
        C_Week = [C_Week; TempPair];
    end
    for j = 1:CellSize(2)
        PostLine = table(C_Name, C_Week(j,1), C_Week(j,2), C_Wkd, C_BgS, C_EdS, C_Pos,C_Week(j,3),...
            'VariableNames',{'className','startWeek','endWeek','weekday','classStartTime','classEndTime','classroom','weekStatus'});
        Post = [Post; PostLine];
    end
end
writetable(Post,'classInfo.xlsx');
clear all;