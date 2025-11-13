/**
 * Clack - Editor de Código Profesional v2.0.0
 * Versión mejorada con seguridad y rendimiento optimizados
 */

'use strict';

// Configuración segura
const APP_CONFIG = {
  name: 'Clack',
  version: '2.0.0',
  maxFileSize: 10 * 1024 * 1024, // 10MB
  maxProjects: 50,
  autoSaveDelay: 5000
};

/**
 * Clase principal de la aplicación
 */
class ClackApp {
  constructor() {
    this.projects = new Map();
    this.currentProject = null;
    this.editors = new Map();
    this.isInitialized = false;
    
    this.init();
  }

  async init() {
    try {
      console.log(`Inicializando ${APP_CONFIG.name} v${APP_CONFIG.version}`);
      
      this.setupEventListeners();
      this.initializeEditors();
      this.loadStoredProjects();
      
      this.isInitialized = true;
      this.showNotification('success', 'Aplicación iniciada', 'Clack está listo');
      
    } catch (error) {
      console.error('Error al inicializar:', error);
      this.showNotification('error', 'Error', 'Error al inicializar la aplicación');
    }
  }

  setupEventListeners() {
    // Atajos de teclado
    document.addEventListener('keydown', (e) => {
      if (e.ctrlKey || e.metaKey) {
        switch(e.key.toLowerCase()) {
          case 's':
            e.preventDefault();
            this.saveCurrentProject();
            break;
          case 'n':
            e.preventDefault();
            this.createNewProject();
            break;
        }
      }
    });

    // Prevenir pérdida de datos
    window.addEventListener('beforeunload', (e) => {
      if (this.hasUnsavedChanges()) {
        e.preventDefault();
        e.returnValue = '¿Seguro que quieres salir? Tienes cambios sin guardar.';
      }
    });
  }

  initializeEditors() {
    const editorTypes = ['html', 'css', 'js'];
    
    editorTypes.forEach(type => {
      const editor = document.getElementById(`${type}Editor`);
      const lineNumbers = document.getElementById(`${type}LineNumbers`);
      
      if (editor) {
        this.setupEditor(editor, type);
        
        if (lineNumbers) {
          this.setupLineNumbers(editor, lineNumbers);
        }
        
        this.editors.set(type, {
          element: editor,
          lineNumbers: lineNumbers,
          lastValue: ''
        });
      }
    });
  }

  setupEditor(editor, type) {
    editor.addEventListener('input', (e) => {
      this.handleEditorInput(type, e);
    });
    
    editor.addEventListener('keydown', (e) => {
      if (e.key === 'Tab') {
        e.preventDefault();
        this.insertTab(editor);
      }
    });
  }

  setupLineNumbers(editor, lineNumbers) {
    this.updateLineNumbers(editor, lineNumbers);
    
    editor.addEventListener('scroll', () => {
      lineNumbers.scrollTop = editor.scrollTop;
    });
  }

  handleEditorInput(type, event) {
    const editor = this.editors.get(type);
    if (!editor) return;

    this.updateLineNumbers(event.target, editor.lineNumbers);
    this.markAsModified();
    this.scheduleAutoSave();
  }

  insertTab(editor) {
    const start = editor.selectionStart;
    const end = editor.selectionEnd;
    const value = editor.value;
    
    editor.value = value.substring(0, start) + '  ' + value.substring(end);
    editor.selectionStart = editor.selectionEnd = start + 2;
  }

  updateLineNumbers(editor, lineNumbers) {
    if (!editor || !lineNumbers) return;
    
    const lines = editor.value.split('\n').length;
    const numbers = Array.from({length: lines}, (_, i) => i + 1).join('\n');
    lineNumbers.textContent = numbers;
  }

  createNewProject() {
    try {
      const projectId = this.generateId();
      const projectName = `Proyecto ${this.projects.size + 1}`;
      
      const newProject = {
        id: projectId,
        name: projectName,
        html: '',
        css: '',
        js: '',
        created: new Date().toISOString(),
        modified: new Date().toISOString()
      };
      
      this.projects.set(projectId, newProject);
      this.currentProject = projectId;
      
      this.clearEditors();
      this.saveProjects();
      
      this.showNotification('success', 'Proyecto creado', `"${projectName}" creado`);
      
    } catch (error) {
      console.error('Error al crear proyecto:', error);
      this.showNotification('error', 'Error', 'No se pudo crear el proyecto');
    }
  }

  generateId() {
    return Date.now().toString(36) + Math.random().toString(36).substring(2);
  }

  clearEditors() {
    this.editors.forEach((editor) => {
      if (editor.element) {
        editor.element.value = '';
        this.updateLineNumbers(editor.element, editor.lineNumbers);
      }
    });
  }

  saveCurrentProject() {
    try {
      if (!this.currentProject) {
        this.createNewProject();
        return;
      }
      
      const project = this.projects.get(this.currentProject);
      if (!project) return;
      
      project.html = this.getEditorValue('html');
      project.css = this.getEditorValue('css');
      project.js = this.getEditorValue('js');
      project.modified = new Date().toISOString();
      
      this.saveProjects();
      this.showNotification('success', 'Guardado', 'Proyecto guardado correctamente');
      
    } catch (error) {
      console.error('Error al guardar:', error);
      this.showNotification('error', 'Error', 'No se pudo guardar el proyecto');
    }
  }

  getEditorValue(type) {
    const editor = this.editors.get(type);
    return editor && editor.element ? editor.element.value : '';
  }

  saveProjects() {
    try {
      const projectsArray = Array.from(this.projects.values());
      
      if (projectsArray.length > APP_CONFIG.maxProjects) {
        projectsArray.splice(APP_CONFIG.maxProjects);
      }
      
      localStorage.setItem('clack_projects', JSON.stringify(projectsArray));
      
    } catch (error) {
      console.error('Error al guardar en localStorage:', error);
    }
  }

  loadStoredProjects() {
    try {
      const stored = localStorage.getItem('clack_projects');
      if (stored) {
        const projects = JSON.parse(stored);
        
        if (Array.isArray(projects)) {
          projects.forEach(project => {
            if (this.validateProject(project)) {
              this.projects.set(project.id, project);
            }
          });
        }
      }
    } catch (error) {
      console.error('Error al cargar proyectos:', error);
    }
  }

  validateProject(project) {
    return project &&
           typeof project.id === 'string' &&
           typeof project.name === 'string' &&
           typeof project.html === 'string' &&
           typeof project.css === 'string' &&
           typeof project.js === 'string';
  }

  openProject(projectId) {
    try {
      const project = this.projects.get(projectId);
      if (!project) {
        this.showNotification('error', 'Error', 'Proyecto no encontrado');
        return;
      }
      
      this.currentProject = projectId;
      
      this.setEditorValue('html', project.html);
      this.setEditorValue('css', project.css);
      this.setEditorValue('js', project.js);
      
      this.showNotification('success', 'Proyecto abierto', `"${project.name}" cargado`);
      
    } catch (error) {
      console.error('Error al abrir proyecto:', error);
      this.showNotification('error', 'Error', 'No se pudo abrir el proyecto');
    }
  }

  setEditorValue(type, value) {
    const editor = this.editors.get(type);
    if (editor && editor.element) {
      editor.element.value = value || '';
      this.updateLineNumbers(editor.element, editor.lineNumbers);
    }
  }

  exportProject() {
    try {
      const html = this.getEditorValue('html');
      const css = this.getEditorValue('css');
      const js = this.getEditorValue('js');
      
      const content = `<!DOCTYPE html>
<html lang="es">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Proyecto Clack</title>
  <style>
${css}
  </style>
</head>
<body>
${html}
  <script>
${js}
  </script>
</body>
</html>`;
      
      const blob = new Blob([content], { type: 'text/html' });
      const url = URL.createObjectURL(blob);
      const a = document.createElement('a');
      a.href = url;
      a.download = 'proyecto-clack.html';
      a.style.display = 'none';
      
      document.body.appendChild(a);
      a.click();
      document.body.removeChild(a);
      
      URL.revokeObjectURL(url);
      
      this.showNotification('success', 'Exportado', 'Proyecto descargado');
      
    } catch (error) {
      console.error('Error al exportar:', error);
      this.showNotification('error', 'Error', 'No se pudo exportar');
    }
  }

  formatCode() {
    try {
      ['html', 'css', 'js'].forEach(type => {
        const editor = this.editors.get(type);
        if (editor && editor.element) {
          const formatted = this.formatCodeByType(editor.element.value, type);
          editor.element.value = formatted;
          this.updateLineNumbers(editor.element, editor.lineNumbers);
        }
      });
      
      this.showNotification('success', 'Formateado', 'Código formateado correctamente');
      
    } catch (error) {
      console.error('Error al formatear:', error);
      this.showNotification('error', 'Error', 'No se pudo formatear el código');
    }
  }

  formatCodeByType(code, type) {
    switch (type) {
      case 'html':
        return this.formatHTML(code);
      case 'css':
        return this.formatCSS(code);
      case 'js':
        return this.formatJS(code);
      default:
        return code;
    }
  }

  formatHTML(html) {
    return html
      .replace(/></g, '>\n<')
      .split('\n')
      .map(line => line.trim())
      .filter(line => line.length > 0)
      .join('\n');
  }

  formatCSS(css) {
    return css
      .replace(/\s*{\s*/g, ' {\n  ')
      .replace(/;\s*/g, ';\n  ')
      .replace(/\s*}\s*/g, '\n}\n\n')
      .trim();
  }

  formatJS(js) {
    return js
      .replace(/\s*{\s*/g, ' {\n  ')
      .replace(/;\s*/g, ';\n  ')
      .replace(/\s*}\s*/g, '\n}\n\n')
      .trim();
  }

  validateCode() {
    try {
      const errors = [];
      
      // Validación básica
      const html = this.getEditorValue('html');
      const css = this.getEditorValue('css');
      const js = this.getEditorValue('js');
      
      // Validar JavaScript
      try {
        if (js.trim()) {
          new Function(js);
        }
      } catch (error) {
        errors.push(`JavaScript: ${error.message}`);
      }
      
      if (errors.length === 0) {
        this.showNotification('success', 'Código válido', 'No se encontraron errores');
      } else {
        this.showNotification('warning', 'Errores encontrados', `${errors.length} errores`);
        console.log('Errores:', errors);
      }
      
    } catch (error) {
      console.error('Error al validar:', error);
      this.showNotification('error', 'Error', 'No se pudo validar el código');
    }
  }

  showNotification(type, title, message, duration = 4000) {
    const container = document.getElementById('toastContainer');
    if (!container) return;
    
    const toast = document.createElement('div');
    toast.className = `toast ${type}`;
    
    toast.innerHTML = `
      <div style="display: flex; align-items: center; gap: 12px;">
        <div style="font-weight: 600;">${this.escapeHtml(title)}</div>
      </div>
      <div style="font-size: 13px; color: var(--text-secondary); margin-top: 4px;">
        ${this.escapeHtml(message)}
      </div>
    `;
    
    container.appendChild(toast);
    
    setTimeout(() => {
      if (toast.parentNode) {
        toast.style.animation = 'slideOut 0.3s ease-out forwards';
        setTimeout(() => {
          if (toast.parentNode) {
            toast.parentNode.removeChild(toast);
          }
        }, 300);
      }
    }, duration);
  }

  escapeHtml(text) {
    const div = document.createElement('div');
    div.textContent = text;
    return div.innerHTML;
  }

  hasUnsavedChanges() {
    if (!this.currentProject) return false;
    
    const project = this.projects.get(this.currentProject);
    if (!project) return false;
    
    return project.html !== this.getEditorValue('html') ||
           project.css !== this.getEditorValue('css') ||
           project.js !== this.getEditorValue('js');
  }

  markAsModified() {
    document.title = document.title.includes('*') ? document.title : document.title + ' *';
  }

  scheduleAutoSave() {
    if (this.autoSaveTimeout) {
      clearTimeout(this.autoSaveTimeout);
    }
    
    this.autoSaveTimeout = setTimeout(() => {
      if (this.hasUnsavedChanges()) {
        this.saveCurrentProject();
      }
    }, APP_CONFIG.autoSaveDelay);
  }
}

// Instancia global
let clackApp;

// Inicializar cuando el DOM esté listo
document.addEventListener('DOMContentLoaded', () => {
  try {
    clackApp = new ClackApp();
    window.clackApp = clackApp;
  } catch (error) {
    console.error('Error al inicializar Clack:', error);
  }
});

// Funciones globales para compatibilidad
function showSection(sectionName) {
  document.querySelectorAll('.section').forEach(s => s.classList.remove('active'));
  document.querySelectorAll('.nav-link').forEach(l => l.classList.remove('active'));
  
  const section = document.getElementById(sectionName);
  if (section) section.classList.add('active');
  
  if (event && event.target) {
    event.target.classList.add('active');
  }
}

function createNewProject() {
  if (clackApp) clackApp.createNewProject();
}

function saveProject() {
  if (clackApp) clackApp.saveCurrentProject();
}

function exportProject() {
  if (clackApp) clackApp.exportProject();
}

function formatCode() {
  if (clackApp) clackApp.formatCode();
}

function validateCode() {
  if (clackApp) clackApp.validateCode();
}

function undoAction() {
  document.execCommand('undo');
  if (clackApp) clackApp.showNotification('info', 'Deshacer', 'Acción deshecha');
}

function redoAction() {
  document.execCommand('redo');
  if (clackApp) clackApp.showNotification('info', 'Rehacer', 'Acción rehecha');
}