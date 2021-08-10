% solve(最大勤務人数(リスト), 勤務可能日(リストのリスト), 最大連勤日数(定数), シフト(リストのリスト))
% solve(MaxWorkers, CanWork, MaxConsecutiveDays, Shift)
solve(_, [], _, []).
solve(MaxWorkers, [CanWorkEmployee | CanWork], MaxConsecutiveDays, [ShiftEmployee | Shift]) :-
    search_employee_shift(MaxWorkers, After, CanWorkEmployee, MaxConsecutiveDays, ShiftEmployee),
    solve(After, CanWork, MaxConsecutiveDays, Shift).

% 従業員一人分の探索
search_employee_shift([], [], [], _, []).
% その曜日に従業員が働けない場合
search_employee_shift([MaxWokersBeforeToday | MaxWokersBefore], [MaxWokersAfterToday | MaxWokersAfter], [CanWorkToday | CanWork], MaxConsecutiveDays, [ShiftToday | Shift]) :-
    search_employee_shift(MaxWokersBefore, MaxWokersAfter, CanWork, MaxConsecutiveDays, Shift),
    CanWorkToday = 0,
    ShiftToday = 0,
    MaxWokersAfterToday = MaxWokersBeforeToday.
% その曜日に従業員が働けて，まだシフトが埋まっていない場合
search_employee_shift([MaxWokersBeforeToday | MaxWokersBefore], [MaxWokersAfterToday | MaxWokersAfter], [CanWorkToday | CanWork], MaxConsecutiveDays, [ShiftToday | Shift]) :-
    search_employee_shift(MaxWokersBefore, MaxWokersAfter, CanWork, MaxConsecutiveDays, Shift),
    CanWorkToday = 1,
    MaxWokersBeforeToday > 0,
    ShiftToday = 1,
    MaxWokersAfterToday is MaxWokersBeforeToday - 1.
% その曜日に従業員が働けるが，シフトが埋まっている場合
search_employee_shift([MaxWokersBeforeToday | MaxWokersBefore], [MaxWokersAfterToday | MaxWokersAfter], [CanWorkToday | CanWork], MaxConsecutiveDays, [ShiftToday | Shift]) :-
    search_employee_shift(MaxWokersBefore, MaxWokersAfter, CanWork, MaxConsecutiveDays, Shift),
    CanWorkToday = 1,
    MaxWokersBeforeToday =< 0,
    ShiftToday = 0,
    MaxWokersAfterToday = MaxWokersBeforeToday.

% シフトが最大連勤日数以下かどうかを調べる
% 最後まで失敗しなければ成功
less_than_max_days(_, _, _, _, 0).
% 最大日数以上の1が並んでいる場合は失敗
less_than_max_days(WeeklyShift, [ShiftToday | Shift], OriginalMaxDays, MaxDays, Loop) :-
    Loop > 0,
    ShiftToday = 1,
    MaxDays2 is MaxDays - 1,
    MaxDays2 < 0,
    fail.
% 最大日数以下で1を見つけた場合は次の日を見る
less_than_max_days(WeeklyShift, [ShiftToday | Shift], OriginalMaxDays, MaxDays, Loop) :-
    Loop > 0,
    ShiftToday = 1,
    MaxDays2 is MaxDays - 1,
    MaxDays2 >= 0,
    less_than_max_days(WeeklyShift, Shift, OriginalMaxDays, MaxDays2, Loop).
% 0を見つけたらシフトの順番を入れ替えて最大日数以下かどうかを調べる
less_than_max_days(WeeklyShift, [ShiftToday | Shift], OriginalMaxDays, MaxDays, Loop) :-
    Loop > 0,
    ShiftToday = 0,
    Loop2 is Loop - 1,
    bring_head_to_last(WeeklyShift, ChangedShift),
    less_than_max_days(ChangedShift, ChangedShift, OriginalMaxDays, OriginalMaxDays, Loop2).

bring_head_to_last([Head | Tail], NewList) :-
    append(Tail, [Head], NewList).
