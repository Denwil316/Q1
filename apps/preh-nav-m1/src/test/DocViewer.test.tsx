import { describe, it, expect, vi } from 'vitest'
import { render, screen } from '@testing-library/react'
import { BrowserRouter } from 'react-router-dom'
import DocViewer from '../components/DocViewer'

vi.mock('../lib/b64url', () => ({
  dec: vi.fn((s: string) => s)
}))

describe('DocViewer', () => {
  it('renders without crashing', () => {
    render(
      <BrowserRouter>
        <DocViewer />
      </BrowserRouter>
    )
    expect(screen.getByText(/Cargando/)).toBeInTheDocument()
  })
})