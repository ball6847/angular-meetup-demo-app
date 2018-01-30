import { async, TestBed } from '@angular/core/testing';
import { FormsModule } from '@angular/forms';

import { AppComponent } from './app.component';
import { Todo } from './todo';
import { TodoDataService } from './todo-data.service';

/* tslint:disable:no-unused-variable */

describe('AppComponent', () => {
  let fixture;
  let app;
  let todoDataService;

  beforeEach(() => {
    TestBed.configureTestingModule({
      imports: [FormsModule],
      declarations: [AppComponent],
      providers: [TodoDataService]
    });
  });

  beforeEach(async(() => {
    fixture = TestBed.createComponent(AppComponent);
    app = fixture.debugElement.componentInstance;
    todoDataService = fixture.debugElement.injector.get(TodoDataService);
  }));

  it('should create the app', async(() => {
    expect(app).toBeTruthy();
  }));

  it(`should have a newTodo todo`, async(() => {
    expect(app.newTodo instanceof Todo).toBeTruthy();
  }));

  it('should display "Todos" in h1 tag', async(() => {
    const compiled = fixture.debugElement.nativeElement;
    expect(compiled.querySelector('h1').textContent).toContain('Angular');
  }));

  it('should add a todo', async(() => {
    spyOn(todoDataService, 'addTodo');
    app.addTodo();
    expect(todoDataService.addTodo).toHaveBeenCalled();
  }));

  it('should complete a todo', async(() => {
    spyOn(todoDataService, 'toggleTodoComplete');
    app.toggleTodoComplete();
    expect(todoDataService.toggleTodoComplete).toHaveBeenCalled();
  }));

  it('should remove a todo', async(() => {
    spyOn(todoDataService, 'deleteTodoById');
    app.removeTodo(1);
    expect(todoDataService.deleteTodoById).toHaveBeenCalled();
  }));
});
