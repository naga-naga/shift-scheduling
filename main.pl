% solve(最大勤務人数(リスト), 勤務可能日(リストのリスト), シフト(リストのリスト))
% solve(MaxWorkers, CanWork, Shift)
solve(_, [], []).
solve(MaxWorkers, [CanWorkEmployee | CanWork], [ShiftEmployee | Shift]) :-
    search_employee_shift(MaxWorkers, After, CanWorkEmployee, ShiftEmployee),
    solve(After, CanWork, Shift).

% 従業員一人分の探索
search_employee_shift([], [], [], []).
% その曜日に従業員が働けない場合
search_employee_shift([MaxWokersBeforeToday | MaxWokersBefore], [MaxWokersAfterToday | MaxWokersAfter], [CanWorkToday | CanWork], [ShiftToday | Shift]) :-
    search_employee_shift(MaxWokersBefore, MaxWokersAfter, CanWork, Shift),
    CanWorkToday = 0,
    ShiftToday = 0,
    MaxWokersAfterToday = MaxWokersBeforeToday.
% その曜日に従業員が働けて，まだシフトが埋まっていない場合
search_employee_shift([MaxWokersBeforeToday | MaxWokersBefore], [MaxWokersAfterToday | MaxWokersAfter], [CanWorkToday | CanWork], [ShiftToday | Shift]) :-
    search_employee_shift(MaxWokersBefore, MaxWokersAfter, CanWork, Shift),
    CanWorkToday = 1,
    MaxWokersBeforeToday > 0,
    ShiftToday = 1,
    MaxWokersAfterToday is MaxWokersBeforeToday - 1.
% その曜日に従業員が働けるが，シフトが埋まっている場合
search_employee_shift([MaxWokersBeforeToday | MaxWokersBefore], [MaxWokersAfterToday | MaxWokersAfter], [CanWorkToday | CanWork], [ShiftToday | Shift]) :-
    search_employee_shift(MaxWokersBefore, MaxWokersAfter, CanWork, Shift),
    CanWorkToday = 1,
    MaxWokersBeforeToday =< 0,
    ShiftToday = 0,
    MaxWokersAfterToday = MaxWokersBeforeToday.
