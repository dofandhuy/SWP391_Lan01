/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Entity;

/**
 *
 * @author Admin
 */

import java.sql.Timestamp;

public class Event {
    private int EventID;
    private String Title, EventType;
    private Timestamp StartTime, EndTime;

    public Event() {
    }

    public Event(int EventID, String Title, String EventType, Timestamp StartTime, Timestamp EndTime) {
        this.EventID = EventID;
        this.Title = Title;
        this.EventType = EventType;
        this.StartTime = StartTime;
        this.EndTime = EndTime;
    }

    public int getEventID() {
        return EventID;
    }

    public void setEventID(int EventID) {
        this.EventID = EventID;
    }

    public String getTitle() {
        return Title;
    }

    public void setTitle(String Title) {
        this.Title = Title;
    }

    public String getEventType() {
        return EventType;
    }

    public void setEventType(String EventType) {
        this.EventType = EventType;
    }

    public Timestamp getStartTime() {
        return StartTime;
    }

    public void setStartTime(Timestamp StartTime) {
        this.StartTime = StartTime;
    }

    public Timestamp getEndTime() {
        return EndTime;
    }

    public void setEndTime(Timestamp EndTime) {
        this.EndTime = EndTime;
    }

    @Override
    public String toString() {
        return "Event{" + "EventID=" + EventID + ", Title=" + Title + ", EventType=" + EventType + ", StartTime=" + StartTime + ", EndTime=" + EndTime + '}';
    }
    
    
}
