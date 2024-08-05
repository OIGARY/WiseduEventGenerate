

Table = readtable("classInfo.xlsx");

% Set Bef & Aft
% Bef 末一天包含 [pointweek,weekday]
% Aft 第一天包含 [pointweek,weekday]

Bef = [4,1];
Aft = [5,2];
Post_A = table();
Post_B = table();

for i = 1:height(Table)
        % 判断是否为调整前
    if Table.endWeek(i) < Bef(1) || (Table.endWeek(i) == Bef(1) && Table.weekday(i) <= Bef(2)) 
        Post_A = [Table(i,:); Post_A];
        % 判断是否为调整后
    elseif Table.startWeek(i) > Aft(1) || (Table.startWeek(i) == Aft(1) && Table.weekday(i) >= Aft(2)) 
        Post_B = [Table(i,:); Post_B];
        % 判断是否为调整过程中
    else
        Line_A = Table(i,:);
        Line_A.endWeek = Bef(1);
        if Line_A.weekday > Bef(2)
            Line_A.endWeek = Bef(1) - 1;
        end
        Post_A = [Line_A; Post_A];

        Line_B = Table(i,:);
        Line_B.startWeek = Aft(1);
        if Line_B.weekday < Aft(2)
            Line_B.startWeek = Aft(1) + 1;
        end
        Post_B = [Line_B; Post_B];
    end
end

Cert_A = table();
Cert_B = table();

for i = 1:height(Post_A)
    if (Post_A.startWeek(i) <= Post_A.endWeek(i))
        Cert_A = [Cert_A; Post_A(i,:)];
    end
end

for i = 1:height(Post_B)
    if (Post_B.startWeek(i) <= Post_B.endWeek(i))
        Cert_B = [Cert_B; Post_B(i,:)];
    end
end

writetable(Cert_A,'classInfo - BA.xlsx');
writetable(Cert_B,'classInfo - AC.xlsx');