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
