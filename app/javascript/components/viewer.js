import Mirador from 'mirador';

class Viewer {
  constructor(config) {
    this.el = config.el;
    this.setupMirador();
  }

  setupMirador() {
    const manifestUri = this.el.getAttribute('manifest-url');

    const config = {
      id: 'viewer',
      workspaceControlPanel: {
        enabled: false
      },
      windows: [
        {
          manifestId: manifestUri,
          thumbnailNavigationPosition: 'far-right',
          view: 'single'
        }
      ],
      manifests: {
        manifestUri: { provider: 'NARA' }
      },
      window: {
        allowClose: false,
        allowMaximize: false,
        sideBarOpenByDefault: false,
        defaultView: 'single'
      },
      workspace: {
        type: 'mosaic',
        showZoomControls: true
      }
    };

    Mirador.viewer(config);
  }
}

const viewers = document.querySelectorAll('.viewer');

[].forEach.call(viewers, viewer => {
  new Viewer({ el: viewer });
});
