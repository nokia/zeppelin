package org.apache.zeppelin.socket;

import org.apache.zeppelin.display.GUI;
import org.apache.zeppelin.notebook.Note;
import org.apache.zeppelin.notebook.Paragraph;
import org.apache.zeppelin.notebook.socket.Message;

import java.util.Map;

class ParagraphBroadcaster {

  private final NotebookServer myServer;

  ParagraphBroadcaster(NotebookServer server) {
    myServer = server;
  }

  void broadcast(Note note, Paragraph p, NotebookSocket sender) {
    if (note.isPersonalizedMode()) {
      Map<String, Paragraph> userParagraphMap = note.getParagraph(p.getId()).getUserParagraphMap();
      broadcastParagraphs(userParagraphMap, sender);
    } else {
      broadcastNoteForms(note, sender);
      myServer.broadcastExcept(note.getId(),
          new Message(Message.OP.PARAGRAPH).put("paragraph", p), sender);
    }
  }

  private void broadcastNoteForms(Note note, NotebookSocket sender) {
    GUI formsSettings = new GUI();
    formsSettings.setForms(note.getNoteForms());
    formsSettings.setParams(note.getNoteParams());

    myServer.broadcastExcept(note.getId(),
        new Message(Message.OP.SAVE_NOTE_FORMS).put("formsData", formsSettings), sender);
  }

  private void broadcastParagraphs(Map<String, Paragraph> userParagraphMap, NotebookSocket sender) {
    if (null != userParagraphMap) {
      for (String user : userParagraphMap.keySet()) {
        multicastToUser(user, new Message(Message.OP.PARAGRAPH).put("paragraph",
            userParagraphMap.get(user)), sender);
      }
    }
  }

  private void multicastToUser(String user, Message m, NotebookSocket sender) {
    if (!myServer.userConnectedSockets.containsKey(user)) {
      myServer.LOG.warn("Multicasting to user {} that is not in connections map", user);
      return;
    }

    for (NotebookSocket conn : myServer.userConnectedSockets.get(user)) {
      if (sender != conn) {
        myServer.unicast(m, conn);
      }
    }
  }
}
