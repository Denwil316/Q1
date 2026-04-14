import React, { useState, useRef } from 'react';

export interface TagInputProps {
  label: string;
  value: string[];
  onChange: (next: string[]) => void;
  placeholder?: string;
  help?: string;
  id?: string;
}

export default function TagInput({ label, value, onChange, placeholder, help, id }: TagInputProps) {
  const [draft, setDraft] = useState('');
  const inputRef = useRef<HTMLInputElement>(null);

  const commit = (txt: string) => {
    const items = txt
      .split(/[\n,;]/g)
      .map(s => s.trim())
      .filter(Boolean);
    if (!items.length) return;
    const next = [...value];
    for (const it of items) if (!next.includes(it)) next.push(it);
    onChange(next);
    setDraft('');
  };

  const onKeyDown: React.KeyboardEventHandler<HTMLInputElement> = (e) => {
    if (e.key === 'Enter' || e.key === ',') {
      e.preventDefault();
      commit(draft);
    } else if (e.key === 'Backspace' && !draft && value.length) {
      const next = value.slice(0, -1);
      onChange(next);
    }
  };

  const onPaste: React.ClipboardEventHandler<HTMLInputElement> = (e) => {
    const text = e.clipboardData.getData('text');
    if (text.includes('\n') || text.includes(',')) {
      e.preventDefault();
      commit(text);
    }
  };

  const remove = (i: number) => {
    const next = value.slice();
    next.splice(i, 1);
    onChange(next);
    inputRef.current?.focus();
  };

  return (
    <div className="field">
      <label className="label" htmlFor={id}>{label}</label>
      <div className="tagbox" onClick={() => inputRef.current?.focus()}>
        {value.map((t, i) => (
          <span key={t} className="tag">
            {t}
            <button type="button" className="tag-x" aria-label={`Quitar ${t}`} onClick={() => remove(i)}>×</button>
          </span>
        ))}
        <input
          ref={inputRef}
          id={id}
          className="tag-input"
          value={draft}
          onChange={e => setDraft(e.target.value)}
          onKeyDown={onKeyDown}
          onPaste={onPaste}
          placeholder={placeholder || 'Escribe y Enter, o pega lista'}
        />
      </div>
      {help && <p className="help">{help}</p>}
    </div>
  );
}
