<%-- 
  DOCTOR APPOINTMENTS PAGE - CANCEL BUTTON INTEGRATION
  
  Add this code to your doctorAppointments.jsp where you display appointment actions
  This allows doctors to cancel appointments, which will free up the time slot
--%>

<!-- EXAMPLE 1: In a table row -->
<tr>
    <td>#<%= rs.getInt("appointment_id") %></td>
    <td><%= rs.getString("patient_name") %></td>
    <td><%= rs.getDate("appointment_date") %></td>
    <td><%= rs.getString("appointment_time") %></td>
    <td>
        <span class="badge <%= badgeClass %>"><%= status %></span>
    </td>
    <td>
        <!-- ACTION BUTTONS -->
        <% 
        String status = rs.getString("status");
        int appointmentId = rs.getInt("appointment_id");
        
        if (status.equals("Pending")) { 
        %>
            <!-- For Pending appointments -->
            <a href="UpdateAppointmentServlet?id=<%= appointmentId %>&status=Confirmed" 
               class="btn btn-success btn-sm"
               title="Confirm Appointment">
                <i class="fas fa-check"></i> Confirm
            </a>
            <a href="DoctorCancelAppointmentServlet?id=<%= appointmentId %>" 
               class="btn btn-danger btn-sm"
               onclick="return confirm('Are you sure you want to cancel this appointment? The patient will be notified and the time slot will be freed.');"
               title="Cancel Appointment">
                <i class="fas fa-times"></i> Cancel
            </a>
        <% 
        } else if (status.equals("Confirmed")) { 
        %>
            <!-- For Confirmed appointments -->
            <a href="startConsultation.jsp?id=<%= appointmentId %>" 
               class="btn btn-primary btn-sm"
               title="Start Consultation">
                <i class="fas fa-video"></i> Start
            </a>
            <a href="UpdateAppointmentServlet?id=<%= appointmentId %>&status=Completed" 
               class="btn btn-info btn-sm"
               onclick="return confirm('Mark this appointment as completed?');"
               title="Mark as Completed">
                <i class="fas fa-check-circle"></i> Complete
            </a>
            <a href="DoctorCancelAppointmentServlet?id=<%= appointmentId %>" 
               class="btn btn-danger btn-sm"
               onclick="return confirm('Cancel this confirmed appointment? The patient will receive a refund notification.');"
               title="Cancel Appointment">
                <i class="fas fa-ban"></i> Cancel
            </a>
        <% 
        } else if (status.equals("Completed")) { 
        %>
            <!-- For Completed appointments -->
            <a href="viewAppointmentDetails.jsp?id=<%= appointmentId %>" 
               class="btn btn-secondary btn-sm"
               title="View Details">
                <i class="fas fa-eye"></i> View
            </a>
        <% 
        } else if (status.equals("Cancelled")) { 
        %>
            <!-- For Cancelled appointments -->
            <span class="text-muted small">No actions available</span>
        <% 
        } 
        %>
    </td>
</tr>

<!-- EXAMPLE 2: In a card layout -->
<div class="col-md-6 mb-3">
    <div class="card">
        <div class="card-body">
            <div class="d-flex justify-content-between align-items-start mb-2">
                <h5 class="card-title">Appointment #<%= appointmentId %></h5>
                <span class="badge <%= badgeClass %>"><%= status %></span>
            </div>
            
            <p class="mb-1"><strong>Patient:</strong> <%= rs.getString("patient_name") %></p>
            <p class="mb-1"><strong>Date:</strong> <%= rs.getDate("appointment_date") %></p>
            <p class="mb-1"><strong>Time:</strong> <%= rs.getString("appointment_time") %></p>
            <p class="mb-3"><strong>Symptoms:</strong> <%= rs.getString("symptoms") %></p>
            
            <div class="btn-group w-100" role="group">
                <% if (status.equals("Pending")) { %>
                    <a href="UpdateAppointmentServlet?id=<%= appointmentId %>&status=Confirmed" 
                       class="btn btn-success btn-sm">
                        <i class="fas fa-check"></i> Confirm
                    </a>
                    <a href="DoctorCancelAppointmentServlet?id=<%= appointmentId %>" 
                       class="btn btn-danger btn-sm"
                       onclick="return confirm('Cancel this appointment?');">
                        <i class="fas fa-times"></i> Cancel
                    </a>
                <% } else if (status.equals("Confirmed")) { %>
                    <a href="startConsultation.jsp?id=<%= appointmentId %>" 
                       class="btn btn-primary btn-sm">
                        <i class="fas fa-video"></i> Start
                    </a>
                    <a href="DoctorCancelAppointmentServlet?id=<%= appointmentId %>" 
                       class="btn btn-danger btn-sm"
                       onclick="return confirm('Cancel this confirmed appointment? Patient will be refunded.');">
                        <i class="fas fa-ban"></i> Cancel
                    </a>
                <% } %>
            </div>
        </div>
    </div>
</div>

<!-- EXAMPLE 3: With cancel reason (if you add cancellation_reason column) -->
<a href="#" 
   class="btn btn-danger btn-sm"
   onclick="cancelAppointmentWithReason(<%= appointmentId %>); return false;">
    <i class="fas fa-times"></i> Cancel
</a>

<script>
function cancelAppointmentWithReason(appointmentId) {
    const reason = prompt("Please provide a reason for cancellation (optional):");
    
    if (reason !== null) { // User didn't click Cancel in prompt
        // Redirect with reason
        window.location.href = 'DoctorCancelAppointmentServlet?id=' + appointmentId + 
                              '&reason=' + encodeURIComponent(reason);
    }
}
</script>

<!-- EXAMPLE 4: Modal-based cancellation with reason -->
<!-- Add this modal to your page -->
<div class="modal fade" id="cancelModal" tabindex="-1">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title">Cancel Appointment</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <form id="cancelForm" action="DoctorCancelAppointmentServlet" method="GET">
                <div class="modal-body">
                    <input type="hidden" name="id" id="cancelAppointmentId">
                    <div class="alert alert-warning">
                        <i class="fas fa-exclamation-triangle"></i>
                        Are you sure you want to cancel this appointment?
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Cancellation Reason (Optional)</label>
                        <textarea class="form-control" name="reason" rows="3" 
                                  placeholder="E.g., Emergency surgery, Doctor unavailable, etc."></textarea>
                    </div>
                    <p class="small text-muted">
                        <i class="fas fa-info-circle"></i> 
                        The patient will be notified and refund will be processed if payment was made.
                    </p>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">
                        No, Keep It
                    </button>
                    <button type="submit" class="btn btn-danger">
                        <i class="fas fa-times"></i> Yes, Cancel Appointment
                    </button>
                </div>
            </form>
        </div>
    </div>
</div>

<!-- Button to trigger modal -->
<button type="button" 
        class="btn btn-danger btn-sm"
        data-bs-toggle="modal" 
        data-bs-target="#cancelModal"
        onclick="document.getElementById('cancelAppointmentId').value = <%= appointmentId %>">
    <i class="fas fa-times"></i> Cancel
</button>

<%-- 
  KEY POINTS:
  1. Always confirm before cancelling with onclick="return confirm(...)"
  2. Different messages for Pending vs Confirmed appointments
  3. Use DoctorCancelAppointmentServlet (not CancelAppointmentServlet - that's for users)
  4. Optional: Add reason parameter for better tracking
  5. Time slot will automatically become available after cancellation
--%>
