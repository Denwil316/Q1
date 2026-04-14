import React from 'react';

export type StepState = 'done' | 'current' | 'todo';
export interface Step {
  key: string;
  title: string;
  state: StepState;
}

export default function Stepper({ steps }: { steps: Step[] }) {
  return (
    <ol className="stepper" aria-label="Progreso del ritual">
      {steps.map((s, idx) => (
        <li key={s.key} className={`step ${s.state}`}>
          <span className="step-index">{idx + 1}</span>
          <span className="step-title">{s.title}</span>
        </li>
      ))}
    </ol>
  );
}
